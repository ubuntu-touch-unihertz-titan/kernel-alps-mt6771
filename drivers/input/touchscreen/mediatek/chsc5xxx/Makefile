#semitouch touchpanel driver

ccflags-y += -I$(srctree)/drivers/input/touchscreen/mediatek/

obj-$(CONFIG_TOUCHSCREEN_MTK_CHSC5432)	    += semi_touch_driver.o

semi_touch_driver-objs += basic_util.o
semi_touch_driver-objs += i2c_communication.o
semi_touch_driver-objs += mtk_core.o
semi_touch_driver-objs += semi_touch_function.o
semi_touch_driver-objs += semi_touch_upgrade.o
semi_touch_driver-objs += semi_touch_apk.o
semi_touch_driver-objs += semi_touch_device.o
semi_touch_driver-objs += semi_touch_custom.o
