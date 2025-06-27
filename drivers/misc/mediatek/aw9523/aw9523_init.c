#include <linux/i2c.h>
#include <linux/module.h>
#include <linux/printk.h>

extern int aw9523_i2c_probe(struct i2c_client *client, const struct i2c_device_id *id);
extern int aw9523_i2c_remove(struct i2c_client *client);

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

// C implementation of aw9523_i2c_init (replacing assembly version)
static int aw9523_i2c_init(void)
{
    int ret;

    pr_info("aw9523_i2c_init: registering I2C driver\n");

    // Register the I2C driver directly
    ret = i2c_add_driver(&aw9523_i2c_driver);
    if (ret) {
        pr_err("aw9523_i2c_init: failed to register I2C driver: %d\n", ret);
        return ret;
    }

    pr_info("aw9523_i2c_init: I2C driver registered successfully\n");
    return 0;
}

static void aw9523_i2c_exit(void)
{
    pr_info("aw9523_i2c_exit: unregistering I2C driver\n");
    i2c_del_driver(&aw9523_i2c_driver);
    pr_info("aw9523 driver unloaded\n");
}

module_init(aw9523_i2c_init);
module_exit(aw9523_i2c_exit);

MODULE_AUTHOR("<liweilei@awinic.com.cn>");
MODULE_DESCRIPTION("AWINIC aw9523 Key Driver");
MODULE_LICENSE("GPL");
