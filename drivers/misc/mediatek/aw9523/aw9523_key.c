#include <linux/module.h>
#include <linux/i2c.h>
#include <linux/input.h>
#include <linux/interrupt.h>
#include <linux/workqueue.h>
#include <linux/hrtimer.h>
#include <linux/delay.h>
#include <linux/mutex.h>
#include <linux/gpio.h>
#include <linux/of_gpio.h>
#include <linux/pinctrl/consumer.h>
#include <linux/device.h>
#include <linux/slab.h>
#include <linux/pm_wakeup.h>
#include <linux/fb.h>
#include <linux/notifier.h>

/**
 * General principles of this driver:
 * 1. Wait for any keypress with an interrupt, all 8 keyboard scan lines are monitored
 * 2. Check each keyboard scan line independently to determine combination of keys depressed
 * 3. Whilst keypresses are detected perform matrix scans to detect further key presses/releases
 * 4. When no keys are pressed return to interrupt based monitoring
 */

#include "aw9523_key.h"

// Data structures
struct aw9523_key_data {
    struct device *dev;
    struct input_dev *input_dev;
    struct mutex lock;
    struct work_struct eint_work;
    struct device_node *irq_node;
    struct hrtimer key_timer;
    int irq;
    bool irq_enabled;
    struct delayed_work work;
    int delay;
    KEY_STATE *keymap;
    int keymap_len;
    int reset_gpio;
    int irq_gpio;
    struct aw9523_pinctrl *pinctrl;
};

struct aw9523_pinctrl {
    struct pinctrl *pinctrl;
    struct pinctrl_state *shdn_high;
    struct pinctrl_state *shdn_low;
    struct pinctrl_state *int_pin;
};

// Global variables
static struct aw9523_key_data *aw9523_key;
static struct i2c_client *aw9523_i2c_client;
static struct workqueue_struct *aw9523_key_wq;

// External function declarations
extern void agold_gpio_set(unsigned gpio, int value);
extern int agold_touchpad_resume_suspend(int suspend);

// Constants
#define AW9523_REG_CHIPID       0x10
#define AW9523_REG_P0           0
#define AW9523_REG_P1           1
#define AW9523_REG_P0_CONFIG    4
#define AW9523_REG_P1_CONFIG    5
#define AW9523_REG_P0_INT       6
#define AW9523_REG_P1_INT       7
#define AW9523_REG_P0_LED       2
#define AW9523_REG_P1_LED       3
#define AW9523_REG_P0_LED_MODE  0x12
#define AW9523_REG_P1_LED_MODE  0x13
#define AW9523_COL_MASK         0x7E
#define AW9523_ALL_RELEASED     0xFF
#define AW9523_SCAN_DELAY_NS    1500000
#define AW9523_RESET_GPIO       158
#define AW9523_IRQ_GPIO_DEFAULT 169
#define AW9523_CHIPID_EXPECTED  0x23
#define AW9523_NUM_COLS         8

// Inline I2C wrappers with mutex
static inline int aw9523_read_reg(struct i2c_client *client, u8 reg)
{
    struct aw9523_key_data *pdata = i2c_get_clientdata(client);
    int ret;
    mutex_lock(&pdata->lock);
    ret = i2c_smbus_read_byte_data(client, reg);
    if (ret < 0)
        dev_err(&client->dev, "i2c read fail: can't read from %02x: %d\n", reg, ret);
    mutex_unlock(&pdata->lock);
    return ret;
}

static inline void aw9523_write_reg(struct i2c_client *client, u8 reg, u8 val)
{
    struct aw9523_key_data *pdata = i2c_get_clientdata(client);
    int ret;
    mutex_lock(&pdata->lock);
    ret = i2c_smbus_write_byte_data(client, reg, val);
    if (ret < 0)
        dev_err(&client->dev, "i2c write fail: can't write %02x to %02x: %d\n", val, reg, ret);
    mutex_unlock(&pdata->lock);
}

// Function declarations
static int aw9523_read_chipid(struct i2c_client *client);
static int agold_key_suspend(void);
int agold_key_resume(void);
void aw9523_key_init(struct i2c_client *client);
static int aw9523_i2c_probe(struct i2c_client *client, const struct i2c_device_id *id);
static int aw9523_i2c_remove(struct i2c_client *client);
static irqreturn_t aw9523_irq(int irq, void *dev_id);
static void aw9523_key_work(struct work_struct *work);
static enum hrtimer_restart aw9523_key_timer_func(struct hrtimer *timer);
int key_fb_notifier_callback(struct notifier_block *self, unsigned long event, void *data);
static ssize_t aw9523_get_reg(struct device *dev, struct device_attribute *attr, char *buf);
static ssize_t aw9523_set_reg(struct device *dev, struct device_attribute *attr, const char *buf, size_t len);

// Device attribute
static DEVICE_ATTR(aw9523_reg, 0644, aw9523_get_reg, aw9523_set_reg);

// FB notifier
static struct notifier_block key_fb_notifier = {
    .notifier_call = key_fb_notifier_callback,
};

// Key state tracking
static unsigned char keyst_old[AW9523_NUM_COLS];
static unsigned char keyst_new[AW9523_NUM_COLS];
static int touchpad_flag = 1;

KEY_STATE key_map[] = {
    /*  name     code              val  row  col */
    { "ENTER",   KEY_ENTER,        0,   4,   2 },
    { "M",       KEY_M,            0,   3,   2 },
    { "N",       KEY_N,            0,   2,   2 },
    { "B",       KEY_B,            0,   1,   2 },
    { "SPACE",   KEY_SPACE,        0,   0,   2 },
    { "V",       KEY_V,            0,   4,   1 },
    { "C",       KEY_C,            0,   3,   1 },
    { "X",       KEY_X,            0,   2,   1 },
    { "Z",       KEY_Z,            0,   1,   1 },
    { "DEL",     KEY_BACKSPACE,    0,   3,   4 },
    { "L",       KEY_L,            0,   2,   4 },
    { "K",       KEY_K,            0,   1,   4 },
    { "J",       KEY_J,            0,   0,   4 },
    { "H",       KEY_H,            0,   4,   3 },
    { "G",       KEY_G,            0,   3,   3 },
    { "F",       KEY_F,            0,   2,   3 },
    { "D",       KEY_D,            0,   1,   3 },
    { "S",       KEY_S,            0,   0,   3 },
    { "A",       KEY_A,            0,   0,   1 },
    { "P",       KEY_P,            0,   4,   4 },
    { "O",       KEY_O,            0,   4,   5 },
    { "I",       KEY_I,            0,   3,   5 },
    { "U",       KEY_U,            0,   2,   5 },
    { "Y",       KEY_Y,            0,   1,   5 },
    { "T",       KEY_T,            0,   0,   5 },
    { "R",       KEY_R,            0,   3,   6 },
    { "E",       KEY_E,            0,   2,   6 },
    { "W",       KEY_W,            0,   1,   6 },
    { "Q",       KEY_Q,            0,   0,   6 },
    { "SYM",     KEY_COMPOSE,      0,   5,   2 },
    { "BACK",    KEY_BACK,         0,   5,   3 },
    { "MENU",    KEY_APPSELECT,    0,   5,   4 },
    { "SHIFT-L", KEY_LEFTSHIFT,    0,   5,   1 },
    { "F13",     KEY_F13,          0,   6,   1 },
    { "ALT",     KEY_RIGHTALT,     0,   7,   1 },
};

// Function implementations
static int noinline aw9523_read_chipid(struct i2c_client *client)
{
    int byte_data;
    int retries = 3;

    while (retries--) {
        byte_data = aw9523_read_reg(client, AW9523_REG_CHIPID);

        if (byte_data >= 0 && (unsigned char)byte_data == AW9523_CHIPID_EXPECTED)
            return 0;

        msleep(5);
    }

    return -EINVAL;
}

static int agold_key_suspend(void)
{
    struct aw9523_key_data *pdata = aw9523_key;
    struct i2c_client *client = aw9523_i2c_client;
    int byte_data;

    byte_data = aw9523_read_reg(client, AW9523_REG_P0_INT);
    if (byte_data >= 0)
        aw9523_write_reg(client, AW9523_REG_P0_INT, 0xFF);

    disable_irq_nosync(pdata->irq);
    agold_gpio_set(AW9523_IRQ_GPIO_DEFAULT, 0);
    msleep(1);
    return 0;
}

int agold_key_resume(void)
{
    struct aw9523_key_data *pdata = aw9523_key;
    struct i2c_client *client = aw9523_i2c_client;
    int byte_data;

    aw9523_key_init(client);  // Keep for init sequence

    byte_data = aw9523_read_reg(client, AW9523_REG_P0);
    byte_data = aw9523_read_reg(client, AW9523_REG_P1);
    byte_data = aw9523_read_reg(client, AW9523_REG_P0_INT);

    aw9523_write_reg(client, AW9523_REG_P0_INT, 0);

    enable_irq(pdata->irq);
    return 0;
}

void aw9523_key_init(struct i2c_client *client)
{
    unsigned char val;

    agold_gpio_set(AW9523_IRQ_GPIO_DEFAULT, 1);
    msleep(1);

    val = aw9523_read_reg(client, AW9523_REG_P0_LED_MODE);
    if (val >= 0)
        aw9523_write_reg(client, AW9523_REG_P0_LED_MODE, 0xFF);

    val = aw9523_read_reg(client, AW9523_REG_P1_LED_MODE);
    if (val >= 0)
        aw9523_write_reg(client, AW9523_REG_P1_LED_MODE, val | AW9523_COL_MASK);

    val = aw9523_read_reg(client, AW9523_REG_P0_INT);
    if (val >= 0)
        aw9523_write_reg(client, AW9523_REG_P0_INT, 0xFF);

    val = aw9523_read_reg(client, AW9523_REG_P1_INT);
    if (val >= 0)
        aw9523_write_reg(client, AW9523_REG_P1_INT, val | AW9523_COL_MASK);

    val = aw9523_read_reg(client, AW9523_REG_P0_CONFIG);
    if (val >= 0)
        aw9523_write_reg(client, AW9523_REG_P0_CONFIG, 0xFF);

    val = aw9523_read_reg(client, AW9523_REG_P1_CONFIG);
    if (val >= 0) {
        aw9523_write_reg(client, AW9523_REG_P1_CONFIG, val & 0x81);
    }

    val = aw9523_read_reg(client, AW9523_REG_P1_LED);
    if (val >= 0) {
        aw9523_write_reg(client, AW9523_REG_P1_LED, val & 0x81);
    }

    val = aw9523_read_reg(client, AW9523_REG_P0);
    val = aw9523_read_reg(client, AW9523_REG_P1);
    val = aw9523_read_reg(client, AW9523_REG_P1_INT);

    aw9523_write_reg(client, AW9523_REG_P0_INT, 0);
}

static int aw9523_i2c_probe(struct i2c_client *client, const struct i2c_device_id *id)
{
    struct aw9523_key_data *pdata;
    struct input_dev *input_dev;
    int i, ret;
    int gpio_flags;
    struct device_node *np = client->dev.of_node;

    dev_info(&client->dev, "%s: probing aw9523 keyboard driver\n", __func__);

    agold_gpio_set(AW9523_RESET_GPIO, 1);

    // Check if I2C functionality supports SMBUS byte data
    if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA)) {
        dev_err(&client->dev, "SMBUS Byte Data not Supported\n");
        return -ENOTSUPP;
    }

    // Allocate memory for private data
    pdata = devm_kzalloc(&client->dev, sizeof(*pdata), GFP_KERNEL);
    if (!pdata) {
        dev_err(&client->dev, "ASoC: Failed to allocate memory\n");
        return -ENOMEM;
    }

    aw9523_key = pdata;
    aw9523_i2c_client = client;

    // Initialize pinctrl
    pdata->pinctrl = devm_kzalloc(&client->dev, sizeof(*pdata->pinctrl), GFP_KERNEL);
    if (!pdata->pinctrl) {
        dev_err(&client->dev, "ASoC: Failed to allocate memory\n");
        return -ENOMEM;
    }

    pdata->pinctrl->pinctrl = devm_pinctrl_get(&client->dev);
    if (IS_ERR(pdata->pinctrl->pinctrl)) {
        dev_err(&client->dev, "%s: failed to get pinctrl\n", __func__);
        return PTR_ERR(pdata->pinctrl->pinctrl);
    }

    // Get pinctrl states
    pdata->pinctrl->shdn_high = pinctrl_lookup_state(pdata->pinctrl->pinctrl, "aw9523_reset_high");
    if (IS_ERR(pdata->pinctrl->shdn_high)) {
        dev_err(&client->dev, "%s: failed to get shdn_high state\n", __func__);
        return PTR_ERR(pdata->pinctrl->shdn_high);
    }

    pdata->pinctrl->shdn_low = pinctrl_lookup_state(pdata->pinctrl->pinctrl, "aw9523_eint");
    if (IS_ERR(pdata->pinctrl->shdn_low)) {
        dev_err(&client->dev, "%s: failed to get shdn_low state\n", __func__);
        return PTR_ERR(pdata->pinctrl->shdn_low);
    }

    pdata->pinctrl->int_pin = pinctrl_lookup_state(pdata->pinctrl->pinctrl, "aw9523_eint");
    if (IS_ERR(pdata->pinctrl->int_pin)) {
        dev_err(&client->dev, "%s: failed to get int_pin state\n", __func__);
        return PTR_ERR(pdata->pinctrl->int_pin);
    }

    // Set pinctrl states
    ret = pinctrl_select_state(pdata->pinctrl->pinctrl, pdata->pinctrl->shdn_high);
    if (ret)
        dev_warn(&client->dev, "%s: failed to select shdn_high state\n", __func__);

    ret = pinctrl_select_state(pdata->pinctrl->pinctrl, pdata->pinctrl->int_pin);
    if (ret)
        dev_warn(&client->dev, "%s: failed to select int_pin state\n", __func__);

    // Get reset GPIO
    gpio_flags = of_get_named_gpio_flags(np, "awinic,reset-gpio", 0, NULL);
    pdata->reset_gpio = gpio_flags;
    if (gpio_flags < 0) {
        dev_err(&client->dev, "%s: failed to get reset gpio\n", __func__);
        return gpio_flags;
    }

    // Request reset GPIO
    ret = gpio_request(pdata->reset_gpio, "aw9523_reset");
    if (ret) {
        dev_err(&client->dev, "%s: unable to request gpio [%d]\n", __func__, pdata->reset_gpio);
        return ret;
    }

    // Set reset GPIO direction and value
    ret = gpio_direction_output(pdata->reset_gpio, 1);
    if (ret) {
        dev_err(&client->dev, "%s: unable to set direction for gpio [%d]\n", __func__, pdata->reset_gpio);
        goto err_free_reset_gpio;
    }

    gpio_set_value(pdata->reset_gpio, 0);
    msleep(1);
    gpio_set_value(pdata->reset_gpio, 1);
    msleep(1);

    // Allocate input device
    input_dev = input_allocate_device();
    if (!input_dev) {
        dev_err(&client->dev, "%s: failed to allocate input device\n", __func__);
        ret = -ENOMEM;
        goto err_free_reset_gpio;
    }

    pdata->input_dev = input_dev;
    pdata->dev = &client->dev;

    // Configure input device
    input_dev->name = "aw9523-key";
    input_dev->phys = "aw9523-keys/input0";
    input_dev->dev.parent = &client->dev;
    input_dev->id.bustype = BUS_I2C;

    // Set up input device capabilities - add all keys from keymap
    set_bit(EV_KEY, input_dev->evbit);
    // Note: Not setting EV_REP to avoid unwanted key repeat

    // Set all key codes from the keymap
    for (i = 0; i < ARRAY_SIZE(key_map); i++) {
        set_bit(key_map[i].key_code, input_dev->keybit);
    }

    // Register input device
    ret = input_register_device(input_dev);
    if (ret) {
        dev_err(&client->dev, "unable to register input device\n");
        goto err_free_input_dev;
    }

    // Get IRQ GPIO
    gpio_flags = of_get_named_gpio_flags(np, "awinic,irq-gpio", 0, NULL);
    pdata->irq_gpio = gpio_flags;
    if (gpio_flags < 0) {
        dev_err(&client->dev, "%s: failed to get irq gpio\n", __func__);
        ret = gpio_flags;
        goto err_unregister_input;
    }

    // Request IRQ GPIO
    ret = gpio_request(pdata->irq_gpio, "aw9523_irq");
    if (ret) {
        dev_err(&client->dev, "%s: unable to request gpio [%d]\n", __func__, pdata->irq_gpio);
        goto err_unregister_input;
    }

    // Set IRQ GPIO direction
    ret = gpio_direction_input(pdata->irq_gpio);
    if (ret) {
        dev_err(&client->dev, "%s: unable to set direction for gpio [%d]\n", __func__, pdata->irq_gpio);
        goto err_free_irq_gpio;
    }

    // Get IRQ number
    pdata->irq = gpio_to_irq(pdata->irq_gpio);
    if (pdata->irq < 0) {
        dev_err(&client->dev, "%s: failed to get irq\n", __func__);
        ret = pdata->irq;
        goto err_free_irq_gpio;
    }

    // Request threaded IRQ
    ret = devm_request_threaded_irq(&client->dev, pdata->irq, NULL, aw9523_irq,
                                   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
                                   "aw9523_irq", client);
    if (ret) {
        dev_err(&client->dev, "%s: failed to request irq %d: %d\n", __func__, pdata->irq, ret);
        goto err_free_irq_gpio;
    }

    dev_info(&client->dev, "%s: keypad, irq %d\n", __func__, pdata->irq);

    // Set IRQ wake
    ret = irq_set_irq_wake(pdata->irq, 1);
    if (ret)
        dev_warn(&client->dev, "%s: failed to set irq wake\n", __func__);

    // Initialize device wakeup
    device_init_wakeup(&client->dev, 1);

    // Initialize workqueue
    aw9523_key_wq = create_singlethread_workqueue("aw9523_key_work");
    if (!aw9523_key_wq) {
        dev_err(&client->dev, "%s: failed to create workqueue\n", __func__);
        ret = -ENOMEM;
        goto err_free_irq_gpio;
    }

    // Initialize work and timer
    INIT_WORK(&pdata->eint_work, aw9523_key_work);
    hrtimer_init(&pdata->key_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
    pdata->key_timer.function = aw9523_key_timer_func;

    // Store private data
    i2c_set_clientdata(client, pdata);

    // Initialize mutex
    mutex_init(&pdata->lock);

    // Initialize key state arrays to 0xFF (all released state)
    memset(keyst_old, 0xFF, AW9523_NUM_COLS);
    memset(keyst_new, 0xFF, AW9523_NUM_COLS);

    // Set up keymap
    pdata->keymap = key_map;
    pdata->keymap_len = ARRAY_SIZE(key_map);

    // Read chip ID
    ret = aw9523_read_chipid(client);
    if (ret) {
        dev_err(&client->dev, "%s: read_chipid error\n", __func__);
        goto err_destroy_wq;
    }

    // Register FB notifier
    ret = fb_register_client(&key_fb_notifier);
    if (ret)
        dev_warn(&client->dev, "%s: register fb_notifier fail!\n", __func__);

    // Create sysfs entry
    ret = device_create_file(&client->dev, &dev_attr_aw9523_reg);
    if (ret)
        dev_warn(&client->dev, "%s: failed to create sysfs file\n", __func__);

    // Initialize keyboard
    aw9523_key_init(client);
    agold_key_suspend();

    dev_info(&client->dev, "%s: aw9523 keyboard driver probed successfully\n", __func__);
    return 0;

err_destroy_wq:
    destroy_workqueue(aw9523_key_wq);
err_free_irq_gpio:
    gpio_free(pdata->irq_gpio);
err_unregister_input:
    input_unregister_device(input_dev);
err_free_input_dev:
    input_free_device(input_dev);
err_free_reset_gpio:
    gpio_free(pdata->reset_gpio);
    return ret;
}

static int aw9523_i2c_remove(struct i2c_client *client)
{
    struct aw9523_key_data *pdata = i2c_get_clientdata(client);

    aw9523_write_reg(client, AW9523_REG_P0, 0);

    free_irq(pdata->irq, client);
    cancel_work_sync(&pdata->eint_work);
    input_unregister_device(pdata->input_dev);
    device_remove_file(&client->dev, &dev_attr_aw9523_reg);
    destroy_workqueue(aw9523_key_wq);

    return 0;
}

static irqreturn_t aw9523_irq(int irq, void *dev_id)
{
    struct i2c_client *client = dev_id;
    struct aw9523_key_data *pdata = i2c_get_clientdata(client);

    aw9523_write_reg(client, AW9523_REG_P0_INT, 0xFF);

    disable_irq_nosync(pdata->irq);
    queue_work(aw9523_key_wq, &pdata->eint_work);

    return IRQ_HANDLED;
}

static void aw9523_key_work(struct work_struct *work)
{
    struct aw9523_key_data *pdata = container_of(work, struct aw9523_key_data, eint_work);
    struct i2c_client *client = aw9523_i2c_client;
    int col, row, key_idx, dummy, reg_val, k;
    unsigned char old_val, new_val, bit, write_val;
    bool all_released = true;

    // Scan columns 1-6, ignore columns 0 and 7
    for (col = 0; col < AW9523_NUM_COLS; col++) {
        if (((1u << col) & AW9523_COL_MASK) != 0) {  // Columns 1-6
            write_val = ((1u << col) & AW9523_COL_MASK) ^ AW9523_COL_MASK;

            aw9523_write_reg(client, AW9523_REG_P1_CONFIG, write_val);

            reg_val = aw9523_read_reg(client, AW9523_REG_P0);
            if (reg_val >= 0)
                keyst_new[col] = (unsigned char)reg_val;
            else
                keyst_new[col] = keyst_old[col];  // Keep old on error
        } else {
            // Columns 0 and 7 remain unchanged (0xFF)
            keyst_new[col] = AW9523_ALL_RELEASED;
        }

        // Check for all released
        if (keyst_new[col] != AW9523_ALL_RELEASED) {
            all_released = false;
        }
    }

    // Process changes for all columns
    for (col = 0; col < AW9523_NUM_COLS; col++) {
        old_val = keyst_old[col];
        new_val = keyst_new[col];

        if (old_val != new_val) {
            for (row = 0; row < AW9523_NUM_COLS; row++) {
                bit = 1u << row;
                if ((old_val ^ new_val) & bit) {
                    // Find key in keymap
                    key_idx = -1;
                    for (k = 0; k < pdata->keymap_len; k++) {
                        if (pdata->keymap[k].row == row && pdata->keymap[k].col == col) {
                            key_idx = k;
                            break;
                        }
                    }
                    if (key_idx != -1) {
                        int key_val = ((new_val & bit) == 0) ? 1 : 0;  // 0 bit = pressed

                        pdata->keymap[key_idx].key_val = key_val;
                        input_event(pdata->input_dev, EV_KEY, pdata->keymap[key_idx].key_code, key_val);
                        input_sync(pdata->input_dev);

                        pr_debug(AW9523_TAG "aw9523_key_work: %s cnt= %d key_report: p0-row= %d col= %d code= %d val= %d\n",
                                pdata->keymap[key_idx].name, 1, row, col,
                                pdata->keymap[key_idx].key_code, key_val);

                        if (key_val == 1 && touchpad_flag == 1) {
                            //agold_touchpad_resume_suspend(1);
                        }
                    }
                }
            }
        }
    }

    // Copy new states to old
    for (col = 0; col < AW9523_NUM_COLS; col++) {
        keyst_old[col] = keyst_new[col];
    }

    if (!all_released) {
        // Still have pressed keys, continue scanning
        hrtimer_start(&pdata->key_timer, ns_to_ktime(1500000), HRTIMER_MODE_REL);
        return;
    }

    // Hardware all-release check
    /* wrapper handles locking and logs errors */
    aw9523_write_reg(client, AW9523_REG_P1_CONFIG, 0);
    dummy = aw9523_read_reg(client, AW9523_REG_P1);
    reg_val = aw9523_read_reg(client, AW9523_REG_P0);

    if ((unsigned char)reg_val == AW9523_ALL_RELEASED) {
        // All keys released
        aw9523_write_reg(client, AW9523_REG_P0_INT, 0);

        if (touchpad_flag == 1) {
            // agold_touchpad_resume_suspend(0);
        }

        enable_irq(pdata->irq);
        pr_debug(AW9523_TAG "aw9523b_key_report all_release\n");
        return;
    }

    // Not all released, continue scanning
    hrtimer_start(&pdata->key_timer, ns_to_ktime(AW9523_SCAN_DELAY_NS), HRTIMER_MODE_REL);
}

static enum hrtimer_restart aw9523_key_timer_func(struct hrtimer *timer)
{
    struct aw9523_key_data *pdata = container_of(timer, struct aw9523_key_data, key_timer);

    queue_work(aw9523_key_wq, &pdata->eint_work);
    return HRTIMER_NORESTART;
}

int key_fb_notifier_callback(struct notifier_block *self, unsigned long event, void *data)
{
    struct fb_event *fb_event = data;
    int *blank = fb_event->data;

    if (event == FB_EVENT_BLANK) {
        if (*blank == FB_BLANK_UNBLANK) {
            agold_key_resume();
        } else if (*blank == FB_BLANK_POWERDOWN) {
            agold_key_suspend();
        }
    }

    return 0;
}

static ssize_t aw9523_get_reg(struct device *dev, struct device_attribute *attr, char *buf)
{
    struct i2c_client *client = to_i2c_client(dev);
    int i, ret;
    ssize_t len = 0;
    unsigned char val;

    for (i = 0; i < 0x30; i++) {
        val = aw9523_read_reg(client, i);
        ret = snprintf(buf + len, PAGE_SIZE - len, "reg[0x%02x] = 0x%02x\n", i, val & 0xff);
        len += ret;
    }

    return len;
}

static ssize_t aw9523_set_reg(struct device *dev, struct device_attribute *attr, const char *buf, size_t len)
{
    struct i2c_client *client = to_i2c_client(dev);
    unsigned int reg, val;

    if (sscanf(buf, "%x %x", &reg, &val) != 2)
        return -EINVAL;

    aw9523_write_reg(client, reg, val);

    return len;
}

// I2C device ID table
static const struct i2c_device_id aw9523_i2c_id[] = {
    {"aw9523-key", 0},
    {}
};

// Device tree matching table
#ifdef CONFIG_OF
static const struct of_device_id aw9523_of_match[] = {
    {.compatible = "awinic,aw9523-key"},
    {},
};
#endif

// I2C driver structure
static struct i2c_driver aw9523_i2c_driver = {
    .driver = {
        .name = "aw9523-key",
        .owner = THIS_MODULE,
#ifdef CONFIG_OF
        .of_match_table = aw9523_of_match,
#endif
    },
    .probe = aw9523_i2c_probe,
    .remove = aw9523_i2c_remove,
    .id_table = aw9523_i2c_id,
};

static int aw9523_i2c_init(void)
{
    int ret;

    ret = i2c_register_driver(THIS_MODULE, &aw9523_i2c_driver);
    if (ret) {
        pr_err(AW9523_TAG "fail to add aw9523 device into i2c\n");
    }

    return ret;
}

static int __init aw9523_module_init(void)
{
    return aw9523_i2c_init();
}
module_init(aw9523_module_init);

static void __exit aw9523_i2c_exit(void)
{
    pr_info(AW9523_TAG "aw9523_i2c_exit: unregistering I2C driver\n");
    i2c_del_driver(&aw9523_i2c_driver);
    pr_info(AW9523_TAG "aw9523 driver unloaded\n");
}

module_exit(aw9523_i2c_exit);

MODULE_AUTHOR("<liweilei@awinic.com.cn>");
MODULE_DESCRIPTION("AWINIC aw9523 Key Driver");
MODULE_LICENSE("GPL");
MODULE_ALIAS("i2c:aw9523");
