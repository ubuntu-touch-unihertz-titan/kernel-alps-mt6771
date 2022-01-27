#define LOG_TAG "LCM"

#ifndef BUILD_LK
#include <linux/string.h>
#include <linux/kernel.h>
#endif

#include "lcm_drv.h"

#ifdef BUILD_LK
#include <platform/upmu_common.h>
#include <platform/mt_gpio.h>
#include <platform/mt_i2c.h>
#include <platform/mt_pmic.h>
#include <string.h>
#elif defined(BUILD_UBOOT)
#include <asm/arch/mt_gpio.h>
#else
/*#include <mach/mt_pm_ldo.h>*/
#ifdef CONFIG_MTK_LEGACY
#include <mach/mt_gpio.h>
#endif
#include <linux/gpio.h>
#endif
#ifdef CONFIG_MTK_LEGACY
#include <cust_gpio_usage.h>
#endif
#ifndef CONFIG_FPGA_EARLY_PORTING
#if defined(CONFIG_MTK_LEGACY)
#include <cust_i2c.h>
#endif
#endif

#ifdef BUILD_LK
#define LCM_LOGI(string, args...)  dprintf(0, "[LK/"LOG_TAG"]"string, ##args)
#define LCM_LOGD(string, args...)  dprintf(1, "[LK/"LOG_TAG"]"string, ##args)
#else
#define LCM_LOGI(fmt, args...)  pr_debug("[KERNEL/"LOG_TAG"]"fmt, ##args)
#define LCM_LOGD(fmt, args...)  pr_debug("[KERNEL/"LOG_TAG"]"fmt, ##args)
#endif

/* AGold hack which calls mtk_gpio_set on pctl->chip in pinctrl-mtk-common */
extern void agold_gpio_set(unsigned offset, int value);

static struct LCM_UTIL_FUNCS lcm_util;

#define MDELAY(n)       (lcm_util.mdelay(n))

#define dsi_set_cmdq_V22(cmdq, cmd, count, ppara, force_update) \
	lcm_util.dsi_set_cmdq_V22(cmdq, cmd, count, ppara, force_update)
#define dsi_set_cmdq_V2(cmd, count, ppara, force_update) \
        lcm_util.dsi_set_cmdq_V2(cmd, count, ppara, force_update)
#define dsi_set_cmdq(pdata, queue_size, force_update) \
        lcm_util.dsi_set_cmdq(pdata, queue_size, force_update)
#define wrtie_cmd(cmd) lcm_util.dsi_write_cmd(cmd)
#define write_regs(addr, pdata, byte_nums) \
        lcm_util.dsi_write_regs(addr, pdata, byte_nums)
#define read_reg(cmd) \
        lcm_util.dsi_dcs_read_lcm_reg(cmd)
#define read_reg_v2(cmd, buffer, buffer_size) \
        lcm_util.dsi_dcs_read_lcm_reg_v2(cmd, buffer, buffer_size)

#define set_gpio_lcd_enp(cmd) \
		lcm_util.set_gpio_lcd_enp_bias(cmd)

/* static unsigned char lcd_id_pins_value = 0xFF; */
//static const unsigned char LCD_MODULE_ID = 0x01;
#define LCM_DSI_CMD_MODE									1
#define FRAME_WIDTH                                     (720)
#define FRAME_HEIGHT                                    (720)

#define REGFLAG_DELAY       0xFFE
#define REGFLAG_END_OF_TABLE    0x100

#ifndef TRUE
#define TRUE 1
#endif

#ifndef FALSE
#define FALSE 0
#endif

struct LCM_setting_table {
	unsigned int cmd;
	unsigned char count;
	unsigned char para_list[11];
};

static struct LCM_setting_table init_setting[] =
{
  { 176, 1, { 0 } },
  { 228, 5, { 0, 0, 0, 0, 8 } },
  { 208, 3, { 69, 69, 113 } },
  { 17, 0, {} },
  { 208, 3, { 82, 74, 113 } },
  { 190, 8, { 255, 15, 0, 24, 4, 4, 0, 93 } },
  { 187, 1, { 47 } },
  { 176, 1, { 3 } },
  { REGFLAG_DELAY, 50, {} },
  { 41, 0, {} },
  { REGFLAG_DELAY, 20, {} },
  { REGFLAG_END_OF_TABLE, 0, {} }
};

static struct LCM_setting_table preinit_setting[] = {
    { 1, 1, { 0 } },
    { REGFLAG_DELAY, 2, {} },
    { REGFLAG_END_OF_TABLE, 0, {} }
};

static struct LCM_setting_table suspend_setting[] = {
	{ 40, 0, {} },
	{ REGFLAG_DELAY, 20, {} },
	{ 16, 0, {} },
	{ REGFLAG_DELAY, 55, {} },
	{ REGFLAG_END_OF_TABLE, 0, {} }
};

static struct LCM_setting_table suspend_setting_2[] = {
	{ 176, 1, { 0 } },
	{ REGFLAG_END_OF_TABLE, 0, {} }
};

static int32_t agold_power_setting_1[] = {
    0, -1, 0xAF, 0xB1, -1, -1, 0
};

static int32_t agold_power_setting_2[] = {
    -1, 0, 0xAF, 0xB1, -1, -1, 0
};

static int32_t agold_power_setting_3[] = {
    -1, -1, 0x19, -1, 0xA, 0xA, 0
};

static struct regulator *lcm_ldo;
static int regulator_inited;

int lcd_ldo_regulator_init(void)
{
	int ret = 0;

	if (regulator_inited)
		return ret;

	/* please only get regulator once in a driver */
	lcm_ldo = regulator_get(NULL, "mt6370_ldo");
	if (IS_ERR(lcm_ldo)) { /* handle return value */
		ret = PTR_ERR(lcm_ldo);
		pr_err("failed to get mt6370_ldo LDO, %d\n", ret);
		return ret;
	}

	/* get current voltage settings */
	ret = regulator_get_voltage(lcm_ldo);
	pr_warn("lcm LDO voltage = %d in LK stage\n", ret);

	regulator_inited = 1;
	return ret; /* must be 0 */
}

int agold_lcmldo_enable(void)
{
	int ret = 0;
	int retval = 0;

	lcd_ldo_regulator_init();

	/* set voltage with min & max*/
	ret = regulator_set_voltage(lcm_ldo, 2800000, 2800000);
	if (ret < 0)
		pr_err("set voltage lcm_ldo fail, ret = %d\n", ret);
	retval |= ret;

	/* enable regulator */
	ret = regulator_enable(lcm_ldo);
	if (ret < 0)
		pr_err("enable regulator lcm_ldo fail, ret = %d\n", ret);
	retval |= ret;

	return retval;
}

int agold_lcmldo_disable(void)
{
	int ret = 0;
	int retval = 0;

	lcd_ldo_regulator_init();

	ret = regulator_disable(lcm_ldo);
	if (ret < 0)
		pr_err("disable regulator lcm_ldo fail, ret = %d\n", ret);
	retval |= ret;

	return retval;
}

extern int agold_display_bias_enable(int pos_factor, int neg_factor);

void agold_lcm_power_on(int32_t *agold_power_setting)
{
	if (!agold_power_setting[0]) {
		agold_gpio_set(agold_power_setting[2], 1);
	}

	if (agold_power_setting[1] == 1) {
		agold_lcmldo_enable();
	} else if (!agold_power_setting[1]) {
		agold_gpio_set(agold_power_setting[3], 1);
	}

	if (agold_power_setting[4] != -1 && agold_power_setting[5] != -1) {
		agold_display_bias_enable(agold_power_setting[4], agold_power_setting[5]);
	}
}

void agold_lcm_power_off(int32_t *agold_power_setting)
{
	if (!agold_power_setting[0] && !agold_power_setting[6]) {
		agold_gpio_set(agold_power_setting[2], 0);
	}

	if (agold_power_setting[1] == 1 ) {
		agold_lcmldo_disable();
	} else if (!agold_power_setting[1]) {
		agold_gpio_set(agold_power_setting[3], 0);
	}

	if (agold_power_setting[4] != -1 && agold_power_setting[5] != -1) {
		display_bias_disable();
		agold_lcmldo_disable();
	}
}

static void push_table(void *cmdq, struct LCM_setting_table *table,
	unsigned int count, unsigned char force_update)
{
	unsigned int i;
	unsigned cmd;

	for (i = 0; i < count; i++) {
		cmd = table[i].cmd;

		switch (cmd) {

			case REGFLAG_DELAY:
                MDELAY(table[i].count);
			case REGFLAG_END_OF_TABLE:
				break;

			default:
				dsi_set_cmdq_V22(0, cmd, table[i].count, table[i].para_list, force_update);
		}
	}
}

static void lcm_set_util_funcs(const struct LCM_UTIL_FUNCS *util)
{
	memcpy(&lcm_util, util, sizeof(struct LCM_UTIL_FUNCS));
}

static void lcm_get_params(struct LCM_PARAMS *params)
{
	memset(params, 0, sizeof(struct LCM_PARAMS));
	params->type   = LCM_TYPE_DSI;

	params->width  = FRAME_WIDTH;
	params->height = FRAME_HEIGHT;
	params->physical_width = 56;
	params->physical_height = 56;

#if 0
	// enable tearing-free
	params->dbi.te_mode 			= LCM_DBI_TE_MODE_VSYNC_OR_HSYNC;
#endif
	params->dbi.io_driving_current = LCM_DRIVING_CURRENT_4MA;
	//params->dbi.te_edge_polarity		= LCM_POLARITY_RISING;

	params->dsi.mode   = BURST_VDO_MODE;
	//params->dsi.switch_mode   = SYNC_PULSE_VDO_MODE;

	// DSI
	/* Command mode setting */
	//1 Three lane or Four lane
	params->dsi.LANE_NUM				= LCM_TWO_LANE;

	//The following defined the fomat for data coming from LCD engine.
	//params->dsi.data_format.color_order = LCM_COLOR_ORDER_RGB;
	params->dsi.data_format.trans_seq   = 0;
	//params->dsi.data_format.padding     = LCM_DSI_PADDING_ON_LSB;
	params->dsi.data_format.format      = LCM_DSI_FORMAT_RGB888;

	// Highly depends on LCD driver capability.
	// Not support in MT6573
	params->dsi.packet_size=256;
	// Video mode setting
	params->dsi.intermediat_buffer_num = 0; /* unused by DSI driver */

	params->dsi.PS=LCM_PACKED_PS_24BIT_RGB888;

	//params->dsi.word_count=FRAME_WIDTH*3;	//DSI CMD mode need set these two bellow params, different to 6577

	params->dsi.vertical_sync_active				= 3;	//10
	params->dsi.vertical_backporch = 4;
	params->dsi.vertical_frontporch = 9;
	params->dsi.vertical_active_line				= FRAME_HEIGHT;

	params->dsi.horizontal_sync_active				= 16;
	params->dsi.horizontal_backporch				= 16;
	params->dsi.horizontal_frontporch				= 96;
	params->dsi.horizontal_active_pixel				= FRAME_WIDTH;

	params->dsi.PLL_CLOCK = 230;
	params->dsi.ssc_disable = 1;
}

static void lcm_init()
{
	LCM_LOGD("%s enter\n", __func__);

	agold_lcm_power_on(agold_power_setting_1);
	MDELAY(10);
	agold_lcm_power_on(agold_power_setting_2);
	MDELAY(5);
	agold_gpio_set(45, 0);
	MDELAY(10);
	agold_gpio_set(45, 1);
	MDELAY(10);

	push_table(0, preinit_setting, sizeof(preinit_setting) / sizeof(struct LCM_setting_table), 1);

	MDELAY(15);
	agold_lcm_power_on(agold_power_setting_3);
	MDELAY(5);

	push_table(0, init_setting, sizeof(init_setting) / sizeof(struct LCM_setting_table), 1);
}

static void lcm_suspend(void)
{
	LCM_LOGD("%s enter\n", __func__);

	push_table(0, suspend_setting, sizeof(suspend_setting) / sizeof(struct LCM_setting_table), 1);

	MDELAY(55);
	agold_lcm_power_off(agold_power_setting_3);
	MDELAY(100);

	push_table(0, suspend_setting_2, sizeof(suspend_setting_2) / sizeof(struct LCM_setting_table), 1);

	agold_gpio_set(45, 0);
	MDELAY(50);
	agold_lcm_power_off(agold_power_setting_2);
	MDELAY(2);
	agold_lcm_power_off(agold_power_setting_1);
	MDELAY(2);

	LCM_LOGD("lcm_suspend end\n");
}

static void lcm_resume(void)
{
	LCM_LOGD("enter lcm_resume\n");
	lcm_init();
	LCM_LOGD("lcm_resume end\n");
}

static unsigned int lcm_compare_id(void)
{
	return 1;
}

struct LCM_DRIVER R63308_CASCADEMDZ40_lcm_drv =
{
    .name			= "R63308_CASCADEMDZ40",
	.set_util_funcs = lcm_set_util_funcs,
	.get_params     = lcm_get_params,
	.init           = lcm_init,
	.compare_id     = lcm_compare_id,
	.resume         = lcm_resume,
	.suspend        = lcm_suspend,
};
