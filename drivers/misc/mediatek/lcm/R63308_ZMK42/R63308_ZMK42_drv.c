#include "lcm_drv.h"

extern void lcm_set_util_funcs(const struct LCM_UTIL_FUNCS *util);
extern void lcm_get_params(struct LCM_PARAMS *params);
extern void lcm_init(void);
extern void lcm_suspend(void);
extern void lcm_resume(void);

static unsigned int lcm_compare_id(void)
{
	return 1;
}

struct LCM_DRIVER R63308_ZMK42_lcm_drv =
{
    .name			= "R63308_ZMK42",
	.set_util_funcs = lcm_set_util_funcs,
	.get_params     = lcm_get_params,
	.init           = lcm_init,
	.compare_id     = lcm_compare_id,
	.resume         = lcm_resume,
	.suspend        = lcm_suspend,
};
