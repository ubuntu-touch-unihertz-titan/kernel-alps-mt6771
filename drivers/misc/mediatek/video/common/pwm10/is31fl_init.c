#include <linux/init.h>
#include <linux/module.h>
#include <linux/i2c.h>
#include <linux/printk.h>

/* External assembly functions */
extern int is31fl_i2c_probe(struct i2c_client *client, const struct i2c_device_id *id);
extern int is31fl_i2c_remove(struct i2c_client *client);

/* I2C device ID table */
static const struct i2c_device_id is31fl_i2c_id[] = {
	{ "is31fl", 0 },
	{ }
};
MODULE_DEVICE_TABLE(i2c, is31fl_i2c_id);

/* I2C driver structure */
static struct i2c_driver is31fl_i2c_driver = {
	.driver = {
		.name = "is31fl",
		.owner = THIS_MODULE,
	},
	.probe = is31fl_i2c_probe,
	.remove = is31fl_i2c_remove,
	.id_table = is31fl_i2c_id,
};

/* Initialization function */
static int __init is31fl_i2c_init(void)
{
	printk("is31fl_i2c_init enter\n");
	return i2c_add_driver(&is31fl_i2c_driver);
}

/* Exit function */
static void __exit is31fl_i2c_exit(void)
{
	i2c_del_driver(&is31fl_i2c_driver);
}

module_init(is31fl_i2c_init);
module_exit(is31fl_i2c_exit);

MODULE_DESCRIPTION("IS31FL LED Driver");
MODULE_LICENSE("GPL");
