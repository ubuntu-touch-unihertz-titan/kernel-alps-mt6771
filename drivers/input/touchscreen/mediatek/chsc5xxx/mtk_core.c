#include <linux/types.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/init.h>
#include <linux/cdev.h>
#include <linux/ide.h>
#include <linux/io.h>
#include <linux/gpio.h>
#include <linux/of_gpio.h>
#include <linux/irq.h>
#include <linux/of_irq.h>
#include <linux/i2c.h>
#include <linux/regulator/consumer.h>

#include "semi_touch_interface.h"
#include "tpd.h"

#define semi_io_free(pin)                   do{ if(gpio_is_valid(pin)) gpio_free(pin); }while(0)
#if defined(CONFIG_PRIZE_HARDWARE_INFO)
#include "../../../misc/mediatek/hardware_info/hardware_info.h"
extern struct hardware_info current_tp_info;
#endif
static const struct of_device_id sm_of_match[] =
{
    {.compatible = "mediatek,chsc_cap_touch", },
    {}
};

static const struct i2c_device_id sm_ts_id[] =
{
    {CHSC_DEVICE_NAME, 0},
    {}
};

int semi_touch_get_irq(int rst_pin)
{
    int irq_no = 0;
    struct device_node* node = NULL;
    unsigned int ints[2] = { 0, 0 };

    node = of_find_matching_node(node, touch_of_match);
    check_return_if_zero(node, NULL);

    of_property_read_u32_array(node, "debounce", ints, ARRAY_SIZE(ints));
    gpio_set_debounce(ints[0], ints[1]);

    irq_no = irq_of_parse_and_map(node, 0);
    check_return_if_fail(irq_no, NULL);

    return irq_no;
}

struct regulator *reg_vdd = NULL;
struct regulator *reg_vio = NULL;

int semi_touch_power_ctrl(unsigned char level)
{
    int ret = SEMI_DRV_ERR_OK;
    static unsigned char power_status = 0; //off

    if(1 == level && 0 == power_status){
        power_status = 1;
        if(!IS_ERR_OR_NULL(reg_vdd)){
            ret = regulator_enable(reg_vdd);
            check_return_if_fail(ret, NULL);
        }
        if(!IS_ERR_OR_NULL(reg_vio)){
            ret = regulator_enable(reg_vio);
            check_return_if_fail(ret, NULL);
        }
        if(st_dev.rst_pin > 0){
            semi_io_direction_out(st_dev.rst_pin, 1);
        }

        kernel_log_d("vdd power up...\n");
    }else if(0 == level && 1 == power_status){
        power_status = 0;
        if(!IS_ERR_OR_NULL(reg_vdd)){
            ret = regulator_disable(reg_vdd);
            check_return_if_fail(ret, NULL);
        }
        if(!IS_ERR_OR_NULL(reg_vio)){
            ret = regulator_disable(reg_vio);
            check_return_if_fail(ret, NULL);
        }
        if(st_dev.rst_pin > 0){
            semi_io_direction_out(st_dev.rst_pin, 0);
        }

        kernel_log_d("vdd power down...\n");
        enter_suspend_gate(st_dev.stc.ctp_run_status);
    }else{
        //don't care
    }

    return ret;
}

int semi_touch_power_exit(void)
{
    int ret = SEMI_DRV_ERR_OK;

    semi_touch_power_ctrl(0);

    if(!IS_ERR_OR_NULL(reg_vdd)){
        ret = regulator_set_voltage(reg_vdd, 0, 0);
        check_return_if_fail(ret, NULL);
        regulator_put(reg_vdd);
    }
    if(!IS_ERR_OR_NULL(reg_vio)){
        ret = regulator_set_voltage(reg_vio, 0, 0);
        check_return_if_fail(ret, NULL);
        regulator_put(reg_vio);
    }

    return ret;
}

int semi_touch_power_init(struct i2c_client *client)
{
    int ret = SEMI_DRV_ERR_OK;
    reg_vdd = regulator_get(&client->dev, "vdd");
    if(IS_ERR_OR_NULL(reg_vdd)){
        kernel_log_d("vdd regulator dts not match\n");
    }

    reg_vio = regulator_get(&client->dev, "vio");
    if(IS_ERR_OR_NULL(reg_vio)){
        kernel_log_d("vio regulator dts not match\n");
    }

    return ret;
}

/********************************************************************************************************************************/
/*virtual key*/
#if 0 == SEMI_TOUCH_VKEY_MAPPING
struct kobject *sm_properties_kobj = NULL;
static ssize_t virtual_keys_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
{
    int index = 0, iter = 0;
    char *vkey_buf = buf;
    for(index = 0; (index < st_dev.stc.vkey_num) && (index < MAX_VKEY_NUMBER); index++)
    {
        iter += sprintf(vkey_buf + iter, "%s:%d:%d:%d:%d:%d%s",
                __stringify(EV_KEY), st_dev.stc.vkey_evt_arr[index],
				st_dev.stc.vkey_dim_map[index][0], st_dev.stc.vkey_dim_map[index][1], 50, 50,
                (index == st_dev.stc.vkey_num - 1) ? "\n" : ":");
    }

    return iter;
}
static struct kobj_attribute virtual_keys_attr =
{
    .attr =
        {
            .name = "virtualkeys.chsc_cap_touch",
            .mode = S_IRUGO,
        },
    .show = &virtual_keys_show,
};
static struct attribute *properties_attrs[] =
{
    &virtual_keys_attr.attr,
    NULL
};
static struct attribute_group properties_attr_group =
{
    .attrs = properties_attrs,
};

int semi_touch_vkey_initialize(void)
{
    int ret = 0;
    sm_properties_kobj = kobject_create_and_add("board_properties", NULL);
    check_return_if_zero(sm_properties_kobj, NULL);

    ret = sysfs_create_group(sm_properties_kobj, &properties_attr_group);
    check_return_if_fail(ret, NULL);

    return ret;
}
#else
#define semi_touch_vkey_initialize()    0
#endif  //SEMI_TOUCH_VKEY_MAPPING
/********************************************************************************************************************************/
/*proximity support*/
#if SEMI_TOUCH_PROXIMITY_OPEN
#include <linux/input.h>
#define PROXIMITY_CLASS_NAME            "chsc_tpd"
#define PROXIMITY_DEVICE_NAME           "device"

/* default cmd interface(refer to sensor HAL):"/sys/class/chsc-tpd/device/proximity" */

struct chsc_proximity
{
    struct class *proximity_cls;
    struct device *proximity_dev;
    struct input_dev *proximity_input;
};

static struct chsc_proximity proximity_obj;

int semi_touch_proximity_init(void)
{
    int ret = 0;

    proximity_obj.proximity_cls = class_create(THIS_MODULE, PROXIMITY_CLASS_NAME);
    check_return_if_fail(proximity_obj.proximity_cls, NULL);

    proximity_obj.proximity_dev = device_create(proximity_obj.proximity_cls, NULL, 0, NULL, PROXIMITY_DEVICE_NAME);
    check_return_if_fail(proximity_obj.proximity_cls, NULL);

    proximity_obj.proximity_input = input_allocate_device();
    check_return_if_zero(proximity_obj.proximity_input, NULL);

    proximity_obj.proximity_input->name = "proximity_tp";
    set_bit(EV_ABS, proximity_obj.proximity_input->evbit);
    input_set_capability(proximity_obj.proximity_input, EV_ABS, ABS_DISTANCE);
    input_set_abs_params(proximity_obj.proximity_input, ABS_DISTANCE, 0, 1, 0, 0);
    ret = input_register_device(proximity_obj.proximity_input);
    check_return_if_fail(ret, NULL);

    open_proximity_function(st_dev.stc.custom_function_en);

    return ret;
}

bool semi_touch_proximity_report(unsigned char proximity)
{
    kernel_log_d("proximity = %d\n", proximity);
    if(is_proximity_function_en(st_dev.stc.custom_function_en))
    {
        input_report_abs(proximity_obj.proximity_input, ABS_DISTANCE, proximity);
        input_mt_sync(proximity_obj.proximity_input);
        input_sync(proximity_obj.proximity_input);
    }

    return true;
}

int semi_touch_proximity_stop(void)
{
    if(proximity_obj.proximity_input)
    {
        input_unregister_device(proximity_obj.proximity_input);
        input_free_device(proximity_obj.proximity_input);
    }
    if(proximity_obj.proximity_dev)
    {
        device_destroy(proximity_obj.proximity_cls, 0);
    }
    if(proximity_obj.proximity_cls)
    {
        class_destroy(proximity_obj.proximity_cls);
    }

    return 0;
}
#endif

int semi_touch_platform_variety(void)
{
    semi_touch_power_exit();

    if(st_dev.int_pin)
    {
        semi_io_free(st_dev.int_pin);
    }

    if(st_dev.rst_pin)
    {
        semi_io_free(st_dev.rst_pin);
    }

#if 0 == SEMI_TOUCH_VKEY_MAPPING
    if(NULL != sm_properties_kobj)
    {
        sysfs_remove_group(sm_properties_kobj, &properties_attr_group);
        kobject_put(sm_properties_kobj);
    }
#endif

    return 0;
}
/********************************************************************************************************************************/
#if(!defined(CONFIG_FB) && !defined(CONFIG_HAS_EARLYSUSPEND) && !defined(CONFIG_DRM))
static const struct dev_pm_ops semi_touch_dev_pm_ops =
{
    .suspend = semi_touch_suspend_entry,
    .resume = semi_touch_resume_entry,
};
#else
static const struct dev_pm_ops semi_touch_dev_pm_ops =
{

};
#endif

#if defined(CONFIG_FB)
#include <linux/notifier.h>
#include <linux/fb.h>
struct notifier_block sm_fb_notify;
static int semi_touch_fb_notifier_callback(struct notifier_block *self, unsigned long event, void *data)
{
    int *blank;
    struct fb_event *evdata = data;
    if(evdata && evdata->data && FB_EVENT_BLANK == event && st_dev.client)
    {
        blank = evdata->data;
        if(FB_BLANK_UNBLANK == *blank)
            semi_touch_resume_entry(&st_dev.client->dev);
        else if(FB_BLANK_POWERDOWN == *blank)
            semi_touch_suspend_entry(&st_dev.client->dev);
    }

    return 0;
}
int semi_touch_work_done(void)
{
    int ret = 0;
    ret = semi_touch_vkey_initialize();
    check_return_if_fail(ret, NULL);

    sm_fb_notify.notifier_call = semi_touch_fb_notifier_callback;
    ret = fb_register_client(&sm_fb_notify);
    check_return_if_fail(ret, NULL);

    return ret;
}
int semi_touch_resource_release(void)
{
    fb_unregister_client(&sm_fb_notify);
    return semi_touch_platform_variety();
}
#elif defined(CONFIG_DRM)
#include <linux/notifier.h>
#include <drm/drm_panel.h>
struct drm_panel *active_panel = NULL;
struct notifier_block sm_fb_notify;
static int semi_touch_drm_notifier_callback(struct notifier_block *self, unsigned long event, void *data)
{
    int *blank;
    struct drm_panel_notifier *evdata = (struct drm_panel_notifier *)data;

    if(evdata && evdata->data && DRM_PANEL_EVENT_BLANK == event && st_dev.client)
    {
        blank = evdata->data;
        if(DRM_PANEL_BLANK_UNBLANK == *blank)
            semi_touch_resume_entry(&st_dev.client->dev);
        else if(DRM_PANEL_BLANK_POWERDOWN == *blank)
            semi_touch_suspend_entry(&st_dev.client->dev);

        //kernel_log_d("drm event = %lu, blank = %d\n", event, *blank);
    }

    return 0;
}
static int semi_touch_drm_get_panel(struct device_node * np)
{
    int index, count;
    struct device_node *node = NULL;
    struct drm_panel *panel = NULL;

    count = of_count_phandle_with_args(np, "panel", NULL);
    if(count <= 0) return -SEMI_DRV_INVALID_PARAM;

    for(index = 0; index < count; index++)
    {
        node = of_parse_phandle(np, "panel", index);
        panel = of_drm_find_panel(node);
        of_node_put(node);
        if (!IS_ERR(panel))
        {
            active_panel = panel;
            return SEMI_DRV_ERR_OK;
        }
    }

    return -SEMI_DRV_ERR_NOT_MATCH;
}
int semi_touch_work_done(void)
{
    int ret = 0;

    ret = semi_touch_vkey_initialize();
    check_return_if_fail(ret, NULL);

    ret = semi_touch_drm_get_panel(st_dev.client->dev.of_node);
    check_return_if_fail(ret, NULL);

    kernel_log_d("register drm notify, active = %x\n", active_panel);

    sm_fb_notify.notifier_call = semi_touch_drm_notifier_callback;
    ret = drm_panel_notifier_register(active_panel, &sm_fb_notify);
    check_return_if_fail(ret, NULL);

    return ret;
}
int semi_touch_resource_release(void)
{
    if(NULL != active_panel)
    {
        drm_panel_notifier_unregister(active_panel, &sm_fb_notify);
    }
    return semi_touch_platform_variety();
}
#elif defined(CONFIG_HAS_EARLYSUSPEND)
#include <linux/earlysuspend.h>
struct early_suspend esp;
static void semi_touch_early_suspend(struct early_suspend* h)
{
    if(NULL == h) return;

    semi_touch_suspend_entry(&st_dev.client->dev);
}
static void semi_touch_late_resume(struct early_suspend* h)
{
    if(NULL == h) return;

    semi_touch_resume_entry(&st_dev.client->dev);
}
int semi_touch_work_done(void)
{
    ret = semi_touch_vkey_initialize();
    check_return_if_fail(ret, NULL);

    esp.level = EARLY_SUSPEND_LEVEL_BLANK_SCREEN + 1;
    esp.suspend = semi_touch_early_suspend;
    esp.resume = semi_touch_late_resume;
    register_early_suspend(&esp);

    return 0;
}
int semi_touch_resource_release(void)
{
    unregister_early_suspend(&esp);
    return semi_touch_platform_variety();
}
#else
int semi_touch_work_done(void)
{
    return 0;
}
int semi_touch_resource_release(void)
{
    return semi_touch_platform_variety();
}
#endif

static ssize_t chsc_version_hardinfo()
{
    int ret;
    unsigned char readBuffer[8] = {0};
  //  kernel_buffer_prepare(szCopy, szKernel, 128);

    ret = semi_touch_read_bytes(0x20000000 + 0x80, readBuffer, 8);
    check_return_if_fail(ret, NULL);

    #if defined(CONFIG_PRIZE_HARDWARE_INFO)
	    sprintf(current_tp_info.chip, "%s","CHSC5448");
		sprintf(current_tp_info.vendor, "0x%02x",readBuffer[1]);
		sprintf(current_tp_info.id,"0x%02x",(readBuffer[3] << 8) + readBuffer[2]);
	   	sprintf(current_tp_info.more,"touchpanel");
    #endif

 //   szCopy += sprintf(szCopy, "Ic type %s\n", mapping_ic_from_type(readBuffer[0]));

 //   szCopy += sprintf(szCopy, "config version is %02X\n", readBuffer[1]);
  //  szCopy += sprintf(szCopy, "vender id is %d, ", readBuffer[4]);
  //  szCopy += sprintf(szCopy, "product id is %d\n", (readBuffer[3] << 8) + readBuffer[2]);

  //  ret = semi_touch_read_bytes(0x20000000 + 0x10, readBuffer, 8);
  //  check_return_if_fail(ret, NULL);

//    szCopy += sprintf(szCopy, "boot version is %04X\n", ((readBuffer[5] << 8) + readBuffer[4]));
  //  szCopy += sprintf(szCopy, "driver version is %s\n", CHSC_DRIVER_VERSION);

    //count = szCopy - szKernel;

//kernel_buffer_to_entry(szKernel, count);

    return 0;
}

static int semi_touch_probe(struct i2c_client *client, const struct i2c_device_id *id)
{
    int ret = 0;

    semi_touch_power_init(client);
    semi_touch_power_ctrl( 1 );

    ret = semi_touch_init(client);
    if(-SEMI_DRV_ERR_HAL_IO == ret)
    {
        semi_touch_deinit(client);
        check_return_if_fail(ret, NULL);
    }

    tpd_load_status = 1;

    chsc_version_hardinfo();
    kernel_log_d("probe finished(result:%d) driver ver(%s)\r\n", ret, CHSC_DRIVER_VERSION);

    return ret;
}

static int semi_touch_remove(struct i2c_client *client)
{
    int ret = 0;

    ret = semi_touch_deinit(client);

    return ret;
}

static int semi_touch_i2c_detect(struct i2c_client *client, struct i2c_board_info *info)
{
    strcpy(info->type, TPD_DEVICE);

    return 0;
}

static struct i2c_driver sm_touch_driver =
{
    .driver =
    {
        .owner = THIS_MODULE,
        .name = "semi_touch",
        .of_match_table = of_match_ptr(sm_of_match),
    },
    .id_table = sm_ts_id,
    .probe = semi_touch_probe,
    .remove = semi_touch_remove,
    .detect = semi_touch_i2c_detect,
};

static int semi_touch_local_init(void)
{
    int ret = 0;

    ret = semi_touch_power_init();
    check_return_if_fail(ret, NULL);

    ret = i2c_add_driver(&sm_touch_driver);
    check_return_if_fail(ret, NULL);

    return ret;
}

void semi_touch_suspend_entry(struct device* dev)
{
    //struct i2c_client *client = st_dev.client;

    if(is_proximity_function_en(st_dev.stc.custom_function_en))
    {
        if(is_proximity_activate(st_dev.stc.ctp_run_status))
        {
            kernel_log_d("proximity is active, so fake suspend...");
            return;
        }
    }

    if(is_guesture_function_en(st_dev.stc.custom_function_en))
    {
        semi_touch_guesture_switch(1);
        enable_irq_wake(st_dev.client->irq);
    }
    else
    {
#if SEMI_TOUCH_SUSPEND_BY_TPCMD
        semi_touch_suspend_ctrl(1);
#else
        semi_touch_power_ctrl( 0 );
#endif
        semi_touch_clear_report();
        //disable_irq(client->irq);
        kernel_log_d("tpd real suspend...\n");
    }
}

void semi_touch_resume_entry(struct device* dev)
{
    unsigned char bootCheckOk = 0;
    unsigned char glove_activity = is_glove_activate(st_dev.stc.ctp_run_status);

    if(is_proximity_function_en(st_dev.stc.custom_function_en))
    {
        if(is_proximity_activate(st_dev.stc.ctp_run_status))
        {
            kernel_log_d("proximity is active, so fake resume...");
            return;
        }
    }
    if(is_guesture_function_en(st_dev.stc.custom_function_en))
    {
        disable_irq_wake(st_dev.client->irq);
    }

#if 0 == SEMI_TOUCH_SUSPEND_BY_TPCMD
    semi_touch_power_ctrl( 1 );
#endif

    //reset tp + iic detected
    semi_touch_reset_and_detect();
    //set_status_pointing(st_dev.stc.ctp_run_status);
    semi_touch_clear_report();
    //enable_irq(client->irq);

    if(glove_activity)
    {
        semi_touch_start_up_check(&bootCheckOk, only_sp_check);
        if(bootCheckOk)
        {
            semi_touch_glove_switch(1);
        }
    }
    kernel_log_d("tpd_resume...\r\n");
}

static struct tpd_driver_t tpd_device_driver =
{
    .tpd_device_name = CHSC_DEVICE_NAME,
    .tpd_local_init = semi_touch_local_init,
    .suspend = semi_touch_suspend_entry,
    .resume = semi_touch_resume_entry,

};

static int __init tpd_driver_init(void)
{
    int ret = 0;

    tpd_get_dts_info();
    ret = tpd_driver_add(&tpd_device_driver);
    check_return_if_fail(ret, NULL);

    return ret;
}

static void __exit tpd_driver_exit(void)
{
    tpd_driver_remove(&tpd_device_driver);
}

module_init(tpd_driver_init);
module_exit(tpd_driver_exit);
MODULE_LICENSE("GPL");
MODULE_AUTHOR("wasim");
