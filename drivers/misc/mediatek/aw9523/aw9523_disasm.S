#include <linux/init.h>
#include <asm/assembler.h>

fp	.req	x29		// frame pointer register

#===================================
.arch armv8-a
#===================================


#===================================
.section .text
#===================================

.align 2
#-----------------------------------
.globl aw9523_read_chipid
.type aw9523_read_chipid, @function
#-----------------------------------
aw9523_read_chipid:

            stp fp,lr,[sp,#-48]!
            stp x22,x21,[sp,#16]
            stp x20,x19,[sp,#32]
            mov fp,sp
            ldr x8,[x0,#184]
            mov x20,x0
            add x19,x0,#32
            add x21,x8,#48
            mov x0,x21
            bl mutex_lock

            mov w1,#16
            mov x0,x20
            bl i2c_smbus_read_byte_data

            mov w3,w0
            tbnz w0,#31,.L_ffffff80089bfe40

            mov x0,x21
            and w22,w3,#255
            bl mutex_unlock

            cmp w22,#35
            b.ne .L_ffffff80089bfe5c

            b .L_ffffff80089bfefc
.L_ffffff80089bfe40:

            adrp x1, .L_ffffff80092ca810
            add x1,x1, :lo12:.L_ffffff80092ca810
            mov w2,#16
            mov x0,x19
            bl dev_err

            mov x0,x21
            bl mutex_unlock
.L_ffffff80089bfe5c:

            mov w0,#5
            bl msleep

            ldr x8,[x20,#184]
            add x21,x8,#48
            mov x0,x21
            bl mutex_lock

            mov w1,#16
            mov x0,x20
            bl i2c_smbus_read_byte_data

            mov w3,w0
            tbnz w0,#31,.L_ffffff80089bfea0

            mov x0,x21
            and w22,w3,#255
            bl mutex_unlock

            cmp w22,#35
            b.ne .L_ffffff80089bfebc

            b .L_ffffff80089bfefc
.L_ffffff80089bfea0:

            adrp x1, .L_ffffff80092ca810
            add x1,x1, :lo12:.L_ffffff80092ca810
            mov w2,#16
            mov x0,x19
            bl dev_err

            mov x0,x21
            bl mutex_unlock
.L_ffffff80089bfebc:

            mov w0,#5
            bl msleep

            ldr x8,[x20,#184]
            add x21,x8,#48
            mov x0,x21
            bl mutex_lock

            mov w1,#16
            mov x0,x20
            bl i2c_smbus_read_byte_data

            mov w3,w0
            tbnz w0,#31,.L_ffffff80089bff04

            mov x0,x21
            and w19,w3,#255
            bl mutex_unlock

            cmp w19,#35
            b.ne .L_ffffff80089bff20
.L_ffffff80089bfefc:

            mov w0,wzr
            b .L_ffffff80089bff2c
.L_ffffff80089bff04:

            adrp x1, .L_ffffff80092ca810
            add x1,x1, :lo12:.L_ffffff80092ca810
            mov w2,#16
            mov x0,x19
            bl dev_err

            mov x0,x21
            bl mutex_unlock
.L_ffffff80089bff20:

            mov w0,#5
            bl msleep

            mov w0,#-22
.L_ffffff80089bff2c:

            ldp x20,x19,[sp,#32]
            ldp x22,x21,[sp,#16]
            ldp fp,lr,[sp],#48
            ret
.size aw9523_read_chipid, . - aw9523_read_chipid
.align 2
#-----------------------------------
.globl agold_key_suspend
.type agold_key_suspend, @function
#-----------------------------------
agold_key_suspend:

            stp fp,lr,[sp,#-32]!
            stp x20,x19,[sp,#16]
            mov fp,sp
            adrp x8, g_aw9523_data
            ldr x8,[x8,:lo12:g_aw9523_data]
            ldr x19,[x8]
            ldr x8,[x19,#184]
            add x20,x8,#48
            mov x0,x20
            bl mutex_lock

            mov w1,#6
            mov x0,x19
            bl i2c_smbus_read_byte_data

            tbz w0,#31,.L_ffffff80089bff8c

            adrp x1, .L_ffffff80092ca810
            mov w3,w0
            add x0,x19,#32
            add x1,x1, :lo12:.L_ffffff80092ca810
            mov w2,#6
            bl dev_err
.L_ffffff80089bff8c:

            mov x0,x20
            bl mutex_unlock

            ldr x8,[x19,#184]
            add x20,x8,#48
            mov x0,x20
            bl mutex_lock

            mov w1,#6
            mov w2,#255
            mov x0,x19
            bl i2c_smbus_write_byte_data

            tbz w0,#31,.L_ffffff80089bffd4

            adrp x1, .L_ffffff80092ca7e2
            mov w4,w0
            add x0,x19,#32
            add x1,x1, :lo12:.L_ffffff80092ca7e2
            mov w2,#255
            mov w3,#6
            bl dev_err
.L_ffffff80089bffd4:

            mov x0,x20
            bl mutex_unlock

            ldr w0,[x19,#744]
            bl disable_irq_nosync

            mov w0,#169
            mov w1,wzr
            bl agold_gpio_set

            mov w0,#1
            bl msleep

            ldp x20,x19,[sp,#16]
            mov w0,wzr
            ldp fp,lr,[sp],#32
            ret
.size agold_key_suspend, . - agold_key_suspend
.align 3
#-----------------------------------
.globl agold_key_resume
.type agold_key_resume, @function
#-----------------------------------
agold_key_resume:

            stp fp,lr,[sp,#-32]!
            stp x20,x19,[sp,#16]
            mov fp,sp
            adrp x8, g_aw9523_data
            ldr x8,[x8,:lo12:g_aw9523_data]
            ldr x19,[x8]
            mov x0,x19
            bl aw9523_key_init

            ldr x8,[x19,#184]
            add x20,x8,#48
            mov x0,x20
            bl mutex_lock

            mov x0,x19
            mov w1,wzr
            bl i2c_smbus_read_byte_data

            tbz w0,#31,.L_ffffff80089c0060

            adrp x1, .L_ffffff80092ca810
            mov w3,w0
            add x0,x19,#32
            add x1,x1, :lo12:.L_ffffff80092ca810
            mov w2,wzr
            bl dev_err
.L_ffffff80089c0060:

            mov x0,x20
            bl mutex_unlock

            ldr x8,[x19,#184]
            add x20,x8,#48
            mov x0,x20
            bl mutex_lock

            mov w1,#1
            mov x0,x19
            bl i2c_smbus_read_byte_data

            tbz w0,#31,.L_ffffff80089c00a0

            adrp x1, .L_ffffff80092ca810
            mov w3,w0
            add x0,x19,#32
            add x1,x1, :lo12:.L_ffffff80092ca810
            mov w2,#1
            bl dev_err
.L_ffffff80089c00a0:

            mov x0,x20
            bl mutex_unlock

            ldr x8,[x19,#184]
            add x20,x8,#48
            mov x0,x20
            bl mutex_lock

            mov w1,#6
            mov x0,x19
            bl i2c_smbus_read_byte_data

            tbz w0,#31,.L_ffffff80089c00e0

            adrp x1, .L_ffffff80092ca810
            mov w3,w0
            add x0,x19,#32
            add x1,x1, :lo12:.L_ffffff80092ca810
            mov w2,#6
            bl dev_err
.L_ffffff80089c00e0:

            mov x0,x20
            bl mutex_unlock

            ldr x8,[x19,#184]
            add x20,x8,#48
            mov x0,x20
            bl mutex_lock

            mov w1,#6
            mov x0,x19
            mov w2,wzr
            bl i2c_smbus_write_byte_data

            tbz w0,#31,.L_ffffff80089c0128

            adrp x1, .L_ffffff80092ca7e2
            mov w4,w0
            add x0,x19,#32
            add x1,x1, :lo12:.L_ffffff80092ca7e2
            mov w3,#6
            mov w2,wzr
            bl dev_err
.L_ffffff80089c0128:

            mov x0,x20
            bl mutex_unlock

            ldr w0,[x19,#744]
            bl enable_irq

            ldp x20,x19,[sp,#16]
            mov w0,wzr
            ldp fp,lr,[sp],#32
            ret
.size agold_key_resume, . - agold_key_resume
.align 3
#-----------------------------------
.globl aw9523_key_init
.type aw9523_key_init, @function
#-----------------------------------
aw9523_key_init:

            stp fp,lr,[sp,#-48]!
            stp x22,x21,[sp,#16]
            stp x20,x19,[sp,#32]
            mov fp,sp
            mov x19,x0
            mov w0,#169
            mov w1,#1
            bl agold_gpio_set

            mov w0,#1
            bl msleep

            ldr x8,[x19,#184]
            add x21,x8,#48
            mov x0,x21
            bl mutex_lock

            mov w1,#18
            mov x0,x19
            bl i2c_smbus_read_byte_data

            mov w20,w0
            tbz w0,#31,.L_ffffff80089c01ac

            adrp x1, .L_ffffff80092ca810
            add x0,x19,#32
            add x1,x1, :lo12:.L_ffffff80092ca810
            mov w2,#18
            mov w3,w20
            bl dev_err
.L_ffffff80089c01ac:

            mov x0,x21
            bl mutex_unlock

            ldr x8,[x19,#184]
            add x21,x8,#48
            mov x0,x21
            bl mutex_lock

            mov w1,#18
            mov w2,#255
            mov x0,x19
            bl i2c_smbus_write_byte_data

            tbz w0,#31,.L_ffffff80089c01f4

            adrp x1, .L_ffffff80092ca7e2
            mov w4,w0
            add x0,x19,#32
            add x1,x1, :lo12:.L_ffffff80092ca7e2
            mov w2,#255
            mov w3,#18
            bl dev_err
.L_ffffff80089c01f4:

            mov x0,x21
            bl mutex_unlock

            ldr x8,[x19,#184]
            add x21,x8,#48
            mov x0,x21
            bl mutex_lock

            mov w1,#19
            mov x0,x19
            bl i2c_smbus_read_byte_data

            mov w3,w0
            tbnz w0,#31,.L_ffffff80089c0228

            mov w20,w3
            b .L_ffffff80089c023c
.L_ffffff80089c0228:

            adrp x1, .L_ffffff80092ca810
            add x0,x19,#32
            add x1,x1, :lo12:.L_ffffff80092ca810
            mov w2,#19
            bl dev_err
.L_ffffff80089c023c:

            mov x0,x21
            bl mutex_unlock

            ldr x8,[x19,#184]
            orr w22,w20,#126
            add x21,x8,#48
            mov x0,x21
            bl mutex_lock

            mov w1,#19
            mov x0,x19
            mov w2,w22
            bl i2c_smbus_write_byte_data

            tbz w0,#31,.L_ffffff80089c0288

            adrp x1, .L_ffffff80092ca7e2
            mov w4,w0
            and w2,w22,#255
            add x0,x19,#32
            add x1,x1, :lo12:.L_ffffff80092ca7e2
            mov w3,#19
            bl dev_err
.L_ffffff80089c0288:

            mov x0,x21
            bl mutex_unlock

            ldr x8,[x19,#184]
            add x21,x8,#48
            mov x0,x21
            bl mutex_lock

            mov w1,#6
            mov x0,x19
            bl i2c_smbus_read_byte_data

            mov w3,w0
            tbnz w0,#31,.L_ffffff80089c02bc

            mov w20,w3
            b .L_ffffff80089c02d0
.L_ffffff80089c02bc:

            adrp x1, .L_ffffff80092ca810
            add x0,x19,#32
            add x1,x1, :lo12:.L_ffffff80092ca810
            mov w2,#6
            bl dev_err
.L_ffffff80089c02d0:

            mov x0,x21
            bl mutex_unlock

            ldr x8,[x19,#184]
            add x21,x8,#48
            mov x0,x21
            bl mutex_lock

            mov w1,#6
            mov w2,#255
            mov x0,x19
            bl i2c_smbus_write_byte_data

            tbz w0,#31,.L_ffffff80089c0318

            adrp x1, .L_ffffff80092ca7e2
            mov w4,w0
            add x0,x19,#32
            add x1,x1, :lo12:.L_ffffff80092ca7e2
            mov w2,#255
            mov w3,#6
            bl dev_err
.L_ffffff80089c0318:

            mov x0,x21
            bl mutex_unlock

            ldr x8,[x19,#184]
            add x21,x8,#48
            mov x0,x21
            bl mutex_lock

            mov w1,#7
            mov x0,x19
            bl i2c_smbus_read_byte_data

            mov w3,w0
            tbnz w0,#31,.L_ffffff80089c034c

            mov w20,w3
            b .L_ffffff80089c0360
.L_ffffff80089c034c:

            adrp x1, .L_ffffff80092ca810
            add x0,x19,#32
            add x1,x1, :lo12:.L_ffffff80092ca810
            mov w2,#7
            bl dev_err
.L_ffffff80089c0360:

            mov x0,x21
            bl mutex_unlock

            ldr x8,[x19,#184]
            orr w22,w20,#126
            add x21,x8,#48
            mov x0,x21
            bl mutex_lock

            mov w1,#7
            mov x0,x19
            mov w2,w22
            bl i2c_smbus_write_byte_data

            tbz w0,#31,.L_ffffff80089c03ac

            adrp x1, .L_ffffff80092ca7e2
            mov w4,w0
            and w2,w22,#255
            add x0,x19,#32
            add x1,x1, :lo12:.L_ffffff80092ca7e2
            mov w3,#7
            bl dev_err
.L_ffffff80089c03ac:

            mov x0,x21
            bl mutex_unlock

            ldr x8,[x19,#184]
            add x21,x8,#48
            mov x0,x21
            bl mutex_lock

            mov w1,#4
            mov x0,x19
            bl i2c_smbus_read_byte_data

            mov w3,w0
            tbnz w0,#31,.L_ffffff80089c03e0

            mov w20,w3
            b .L_ffffff80089c03f4
.L_ffffff80089c03e0:

            adrp x1, .L_ffffff80092ca810
            add x0,x19,#32
            add x1,x1, :lo12:.L_ffffff80092ca810
            mov w2,#4
            bl dev_err
.L_ffffff80089c03f4:

            mov x0,x21
            bl mutex_unlock

            ldr x8,[x19,#184]
            add x21,x8,#48
            mov x0,x21
            bl mutex_lock

            mov w1,#4
            mov w2,#255
            mov x0,x19
            bl i2c_smbus_write_byte_data

            tbz w0,#31,.L_ffffff80089c043c

            adrp x1, .L_ffffff80092ca7e2
            mov w4,w0
            add x0,x19,#32
            add x1,x1, :lo12:.L_ffffff80092ca7e2
            mov w2,#255
            mov w3,#4
            bl dev_err
.L_ffffff80089c043c:

            mov x0,x21
            bl mutex_unlock

            ldr x8,[x19,#184]
            add x21,x8,#48
            mov x0,x21
            bl mutex_lock

            mov w1,#5
            mov x0,x19
            bl i2c_smbus_read_byte_data

            mov w3,w0
            tbnz w0,#31,.L_ffffff80089c0470

            mov w20,w3
            b .L_ffffff80089c0484
.L_ffffff80089c0470:

            adrp x1, .L_ffffff80092ca810
            add x0,x19,#32
            add x1,x1, :lo12:.L_ffffff80092ca810
            mov w2,#5
            bl dev_err
.L_ffffff80089c0484:

            mov x0,x21
            bl mutex_unlock

            ldr x8,[x19,#184]
            and w20,w20,#4294967169
            add x21,x8,#48
            mov x0,x21
            bl mutex_lock

            mov w1,#5
            mov x0,x19
            mov w2,w20
            bl i2c_smbus_write_byte_data

            tbz w0,#31,.L_ffffff80089c04d0

            adrp x1, .L_ffffff80092ca7e2
            mov w4,w0
            and w2,w20,#255
            add x0,x19,#32
            add x1,x1, :lo12:.L_ffffff80092ca7e2
            mov w3,#5
            bl dev_err
.L_ffffff80089c04d0:

            mov x0,x21
            bl mutex_unlock

            ldr x8,[x19,#184]
            add x21,x8,#48
            mov x0,x21
            bl mutex_lock

            mov w1,#3
            mov x0,x19
            bl i2c_smbus_read_byte_data

            mov w3,w0
            tbnz w0,#31,.L_ffffff80089c0504

            and w20,w3,#4294967169
            b .L_ffffff80089c0518
.L_ffffff80089c0504:

            adrp x1, .L_ffffff80092ca810
            add x0,x19,#32
            add x1,x1, :lo12:.L_ffffff80092ca810
            mov w2,#3
            bl dev_err
.L_ffffff80089c0518:

            mov x0,x21
            bl mutex_unlock

            ldr x8,[x19,#184]
            add x21,x8,#48
            mov x0,x21
            bl mutex_lock

            mov w1,#3
            mov x0,x19
            mov w2,w20
            bl i2c_smbus_write_byte_data

            tbz w0,#31,.L_ffffff80089c0560

            adrp x1, .L_ffffff80092ca7e2
            mov w4,w0
            and w2,w20,#255
            add x0,x19,#32
            add x1,x1, :lo12:.L_ffffff80092ca7e2
            mov w3,#3
            bl dev_err
.L_ffffff80089c0560:

            mov x0,x21
            bl mutex_unlock

            ldr x8,[x19,#184]
            add x20,x8,#48
            mov x0,x20
            bl mutex_lock

            mov x0,x19
            mov w1,wzr
            bl i2c_smbus_read_byte_data

            tbz w0,#31,.L_ffffff80089c05a0

            adrp x1, .L_ffffff80092ca810
            mov w3,w0
            add x0,x19,#32
            add x1,x1, :lo12:.L_ffffff80092ca810
            mov w2,wzr
            bl dev_err
.L_ffffff80089c05a0:

            mov x0,x20
            bl mutex_unlock

            ldr x8,[x19,#184]
            add x20,x8,#48
            mov x0,x20
            bl mutex_lock

            mov w1,#1
            mov x0,x19
            bl i2c_smbus_read_byte_data

            tbz w0,#31,.L_ffffff80089c05e0

            adrp x1, .L_ffffff80092ca810
            mov w3,w0
            add x0,x19,#32
            add x1,x1, :lo12:.L_ffffff80092ca810
            mov w2,#1
            bl dev_err
.L_ffffff80089c05e0:

            mov x0,x20
            bl mutex_unlock

            ldr x8,[x19,#184]
            add x20,x8,#48
            mov x0,x20
            bl mutex_lock

            mov w1,#6
            mov x0,x19
            bl i2c_smbus_read_byte_data

            tbz w0,#31,.L_ffffff80089c0620

            adrp x1, .L_ffffff80092ca810
            mov w3,w0
            add x0,x19,#32
            add x1,x1, :lo12:.L_ffffff80092ca810
            mov w2,#6
            bl dev_err
.L_ffffff80089c0620:

            mov x0,x20
            bl mutex_unlock

            ldr x8,[x19,#184]
            add x20,x8,#48
            mov x0,x20
            bl mutex_lock

            mov w1,#6
            mov x0,x19
            mov w2,wzr
            bl i2c_smbus_write_byte_data

            tbz w0,#31,.L_ffffff80089c0668

            adrp x1, .L_ffffff80092ca7e2
            mov w4,w0
            add x0,x19,#32
            add x1,x1, :lo12:.L_ffffff80092ca7e2
            mov w3,#6
            mov w2,wzr
            bl dev_err
.L_ffffff80089c0668:

            mov x0,x20
            bl mutex_unlock

            ldp x20,x19,[sp,#32]
            ldp x22,x21,[sp,#16]
            ldp fp,lr,[sp],#48
            ret
.size aw9523_key_init, . - aw9523_key_init
.align 4
#-----------------------------------
.globl aw9523_i2c_probe
.type aw9523_i2c_probe, @function
#-----------------------------------
aw9523_i2c_probe:

            stp fp,lr,[sp,#-48]!
            stp x22,x21,[sp,#16]
            stp x20,x19,[sp,#32]
            mov fp,sp
            mov x21,x0
            add x19,x0,#32
            mov w0,#158
            mov w1,#1
            bl agold_gpio_set

            ldr x0,[x21,#24]
            ldr x8,[x0,#16]
            ldr x8,[x8,#16]
            blr x8

            mvn w8,w0
            tst w8,#1572864
            b.ne .L_ffffff80089c0704

            mov w2,#32960
            mov w1,#224
            movk w2,#320,lsl #16
            mov x0,x19
            bl devm_kmalloc

            cbz x0,.L_ffffff80089c071c

            adrp x8, g_aw9523_data
            mov x20,x0
            str x0,[x8,:lo12:g_aw9523_data]
            mov x0,x19
            bl devm_pinctrl_get

            cmn x0,#4095
            str x0,[x20,#16]
            b.lo .L_ffffff80089c0734

            adrp x0, .L_ffffff8009263b1f
            add x0,x0, :lo12:.L_ffffff8009263b1f
            b .L_ffffff80089c0770
.L_ffffff80089c0704:

            adrp x1, .L_ffffff8009287ddf
            add x1,x1, :lo12:.L_ffffff8009287ddf
            mov x0,x19
            bl dev_err

            mov w22,#-5
            b .L_ffffff80089c0780
.L_ffffff80089c071c:

            adrp x1, .L_ffffff8009201e3d
            add x1,x1, :lo12:.L_ffffff8009201e3d
            mov x0,x19
            bl dev_err

            mov w22,#-12
            b .L_ffffff80089c0780
.L_ffffff80089c0734:

            adrp x1, .L_ffffff800915fb1f
            add x1,x1, :lo12:.L_ffffff800915fb1f
            bl pinctrl_lookup_state

            cmn x0,#4095
            str x0,[x20,#32]
            b.hs .L_ffffff80089c0768

            ldr x0,[x20,#16]
            adrp x1, .L_ffffff80091984f6
            add x1,x1, :lo12:.L_ffffff80091984f6
            bl pinctrl_lookup_state

            cmn x0,#4095
            str x0,[x20,#24]
            b.lo .L_ffffff80089c0794
.L_ffffff80089c0768:

            adrp x0, .L_ffffff8009274ec5
            add x0,x0, :lo12:.L_ffffff8009274ec5
.L_ffffff80089c0770:

            adrp x1, .L_ffffff80091b099f
            add x1,x1, :lo12:.L_ffffff80091b099f
            bl printk
.L_ffffff80089c077c:

            mov w22,#-22
.L_ffffff80089c0780:

            mov w0,w22
            ldp x20,x19,[sp,#32]
            ldp x22,x21,[sp,#16]
            ldp fp,lr,[sp],#48
            ret
.L_ffffff80089c0794:

            ldr x0,[x20,#16]
            adrp x1, .L_ffffff800916808d
            add x1,x1, :lo12:.L_ffffff800916808d
            bl pinctrl_lookup_state

            cmn x0,#4095
            str x0,[x20,#40]
            b.lo .L_ffffff80089c07bc

            adrp x0, .L_ffffff8009274ee6
            add x0,x0, :lo12:.L_ffffff8009274ee6
            b .L_ffffff80089c0770
.L_ffffff80089c07bc:

            ldp x0,x1,[x20,#16]
            bl pinctrl_select_state

            cbz w0,.L_ffffff80089c07dc

            adrp x0, .L_ffffff800932cd74
            adrp x1, .L_ffffff80091b099f
            add x0,x0, :lo12:.L_ffffff800932cd74
            add x1,x1, :lo12:.L_ffffff80091b099f
            bl printk
.L_ffffff80089c07dc:

            ldr x0,[x20,#16]
            ldr x1,[x20,#40]
            bl pinctrl_select_state

            cbz w0,.L_ffffff80089c0800

            adrp x0, .L_ffffff800932cd96
            adrp x1, .L_ffffff80091b099f
            add x0,x0, :lo12:.L_ffffff800932cd96
            add x1,x1, :lo12:.L_ffffff80091b099f
            bl printk
.L_ffffff80089c0800:

            ldr x0,[x21,#616]
            adrp x1, .L_ffffff80091865cb
            add x1,x1, :lo12:.L_ffffff80091865cb
            mov w2,wzr
            mov x3,xzr
            bl of_get_named_gpio_flags

            cmp w0,#511
            str w0,[x20,#96]
            b.hi .L_ffffff80089c077c

            adrp x1, .L_ffffff80091865d2
            add x1,x1, :lo12:.L_ffffff80091865d2
            bl gpio_request

            ldr w3,[x20,#96]
            cbz w0,.L_ffffff80089c0844
.L_ffffff80089c0838:

            adrp x1, .L_ffffff80092db361
            add x1,x1, :lo12:.L_ffffff80092db361
            b .L_ffffff80089c0864
.L_ffffff80089c0844:

            mov w0,w3
            bl gpio_to_desc

            mov w1,#1
            bl gpiod_direction_output_raw

            ldr w3,[x20,#96]
            cbz w0,.L_ffffff80089c0898

            adrp x1, .L_ffffff80092db382
            add x1,x1, :lo12:.L_ffffff80092db382
.L_ffffff80089c0864:

            adrp x2, .L_ffffff80091b099f
            add x2,x2, :lo12:.L_ffffff80091b099f
            mov x0,x19
            bl dev_err
.L_ffffff80089c0874:

            ldr w0,[x20,#96]
            bl gpio_free

            mov w22,wzr
.L_ffffff80089c0880:

            ldr x0,[x20,#8]
            bl input_free_device

            mov x0,x19
            mov x1,x20
            bl devm_kfree

            b .L_ffffff80089c0780
.L_ffffff80089c0898:

            mov w0,w3
            bl gpio_to_desc

            mov w1,wzr
            bl gpiod_set_raw_value

            mov w0,#1
            bl msleep

            ldr w0,[x20,#96]
            bl gpio_to_desc

            mov w1,#1
            bl gpiod_set_raw_value

            mov w0,#1
            bl msleep

            str x21,[x20]
            bl input_allocate_device

            str x0,[x20,#8]
            cbz x0,.L_ffffff80089c09b0

            adrp x8, .L_ffffff800915b9eb
            add x8,x8, :lo12:.L_ffffff800915b9eb
            str x8,[x0]
            ldr x8,[x20,#8]
            adrp x9, .L_ffffff80091f1101
            add x9,x9, :lo12:.L_ffffff80091f1101
            str x9,[x8,#8]
            ldr x8,[x20,#8]
            str x19,[x8,#544]
            ldr x9,[x20,#8]
            mov w8,#35
            str w8,[x20,#112]
            adrp x8, .L_ffffff8009a01848
            add x8,x8, :lo12:.L_ffffff8009a01848
            str x8,[x20,#104]
            str x20,[x9,#696]
            ldr x8,[x20,#8]
            ldr x9,[x8,#40]
            orr x9,x9,#2
            str x9,[x8,#40]
            ldr x8,[x20,#8]
            ldr x9,[x8,#40]
            orr x9,x9,#1
            str x9,[x8,#40]
            ldr w8,[x20,#112]
            cmp w8,#1
            b.lt .L_ffffff80089c098c

            mov x8,xzr
            mov w9,#12
            mov w10,#1
            mov w11,#88
.L_ffffff80089c0954:

            ldr x12,[x20,#104]
            ldr x13,[x20,#8]
            add x8,x8,#1
            ldr w12,[x12,x9]
            add x9,x9,#28
            and x14,x11,x12, lsr #3
            add x13,x13,x14
            ldr x14,[x13,#48]
            lsl x12,x10,x12
            orr x12,x12,x14
            str x12,[x13,#48]
            ldrsw x12,[x20,#112]
            cmp x8,x12
            b.lt .L_ffffff80089c0954
.L_ffffff80089c098c:

            ldr x0,[x20,#8]
            bl input_register_device

            cbz w0,.L_ffffff80089c09d0

            adrp x1, .L_ffffff800927fa48
            mov w22,w0
            add x1,x1, :lo12:.L_ffffff800927fa48
            mov x0,x19
            bl dev_err

            b .L_ffffff80089c0880
.L_ffffff80089c09b0:

            adrp x1, .L_ffffff800927fa8c
            adrp x2, .L_ffffff80091b099f
            add x1,x1, :lo12:.L_ffffff800927fa8c
            add x2,x2, :lo12:.L_ffffff80091b099f
            mov x0,x19
            bl dev_err

            mov w22,#-12
            b .L_ffffff80089c0880
.L_ffffff80089c09d0:

            ldr x0,[x21,#616]
            adrp x1, .L_ffffff8009186641
            add x1,x1, :lo12:.L_ffffff8009186641
            mov w2,wzr
            mov x3,xzr
            bl of_get_named_gpio_flags

            cmp w0,#511
            str w0,[x20,#92]
            b.hi .L_ffffff80089c077c

            adrp x1, .L_ffffff8009186648
            add x1,x1, :lo12:.L_ffffff8009186648
            bl gpio_request

            ldr w3,[x20,#92]
            cbnz w0,.L_ffffff80089c0838

            mov w0,w3
            bl gpio_to_desc

            bl gpiod_direction_input

            ldr w3,[x20,#92]
            cbz w0,.L_ffffff80089c0a40

            adrp x1, .L_ffffff80092db382
            adrp x2, .L_ffffff80091b099f
            add x1,x1, :lo12:.L_ffffff80092db382
            add x2,x2, :lo12:.L_ffffff80091b099f
            mov x0,x19
            bl dev_err
.L_ffffff80089c0a34:

            ldr w0,[x20,#92]
            bl gpio_free

            b .L_ffffff80089c0874
.L_ffffff80089c0a40:

            mov w0,w3
            bl gpio_to_desc

            bl gpiod_to_irq

            str w0,[x21,#744]
            tbnz w0,#31,.L_ffffff80089c0a34

            adrp x3, aw9523_irq
            adrp x5, .L_ffffff8009182496
            mov w1,w0
            add x3,x3, :lo12:aw9523_irq
            add x5,x5, :lo12:.L_ffffff8009182496
            mov w4,#8200
            mov x0,x19
            mov x2,xzr
            mov x6,x21
            bl devm_request_threaded_irq

            ldr w3,[x21,#744]
            cbz w0,.L_ffffff80089c0aa4

            adrp x1, .L_ffffff80092c1448
            adrp x2, .L_ffffff80091b099f
            mov w4,w0
            add x1,x1, :lo12:.L_ffffff80092c1448
            add x2,x2, :lo12:.L_ffffff80091b099f
            mov x0,x19
            bl dev_err

            b .L_ffffff80089c0a34
.L_ffffff80089c0aa4:

            adrp x1, .L_ffffff80092b5db8
            adrp x2, .L_ffffff80091b099f
            add x1,x1, :lo12:.L_ffffff80092b5db8
            add x2,x2, :lo12:.L_ffffff80091b099f
            mov x0,x19
            bl _dev_info

            ldr w0,[x21,#744]
            mov w1,#1
            bl irq_set_irq_wake

            mov w1,#1
            mov x0,x19
            bl device_init_wakeup

            adrp x10, aw9523_key_work
            mov x8,#68719476704
            add x9,x20,#200
            add x10,x10, :lo12:aw9523_key_work
            add x0,x20,#128
            mov w1,#1
            mov w2,#1
            str x8,[x20,#192]
            str x9,[x20,#200]
            stp x9,x10,[x20,#208]
            bl hrtimer_init

            adrp x8, aw9523_key_timer_func
            adrp x1, .L_ffffff8009194dfa
            adrp x2, .L_ffffff800a24e740
            add x8,x8, :lo12:aw9523_key_timer_func
            add x0,x20,#48
            add x1,x1, :lo12:.L_ffffff8009194dfa
            add x2,x2, :lo12:.L_ffffff800a24e740
            str x8,[x20,#168]
            str x20,[x21,#184]
            bl __mutex_init

            mov x0,x21
            bl aw9523_read_chipid

            cbz w0,.L_ffffff80089c0b50

            adrp x1, .L_ffffff8009252758
            adrp x2, .L_ffffff80091b099f
            add x1,x1, :lo12:.L_ffffff8009252758
            add x2,x2, :lo12:.L_ffffff80091b099f
            mov x0,x19
            bl dev_err

            b .L_ffffff80089c0a34
.L_ffffff80089c0b50:

            adrp x0, .L_ffffff800a24e748
            adrp x8, key_fb_notifier_callback
            add x0,x0, :lo12:.L_ffffff800a24e748
            add x8,x8, :lo12:key_fb_notifier_callback
            str x8,[x0]
            bl fb_register_client

            cbz w0,.L_ffffff80089c0b78

            adrp x0, .L_ffffff8009329061
            add x0,x0, :lo12:.L_ffffff8009329061
            bl printk
.L_ffffff80089c0b78:

            adrp x1, .L_ffffff8009a01d08
            add x1,x1, :lo12:.L_ffffff8009a01d08
            mov x0,x19
            bl device_create_file

            adrp x8, .L_ffffff800a24e760
            adrp x10, .L_ffffff800a24e770
            add x8,x8, :lo12:.L_ffffff800a24e760
            mov x9,#-1
            add x10,x10, :lo12:.L_ffffff800a24e770
            mov x0,x21
            stp x9,x9,[x8]
            stp x9,x9,[x10]
            bl aw9523_key_init

            bl agold_key_suspend

            mov w22,wzr
            b .L_ffffff80089c0780
.size aw9523_i2c_probe, . - aw9523_i2c_probe
.align 3
#-----------------------------------
.globl aw9523_i2c_remove
.type aw9523_i2c_remove, @function
#-----------------------------------
aw9523_i2c_remove:

            stp fp,lr,[sp,#-48]!
            str x21,[sp,#16]
            stp x20,x19,[sp,#32]
            mov fp,sp
            ldr x19,[x0,#184]
            mov x20,x0
            add x21,x19,#48
            mov x0,x21
            bl mutex_lock

            mov x0,x20
            mov w1,wzr
            mov w2,wzr
            bl i2c_smbus_write_byte_data

            tbz w0,#31,.L_ffffff80089c0c0c

            adrp x1, .L_ffffff80092ca7e2
            mov w4,w0
            add x0,x20,#32
            add x1,x1, :lo12:.L_ffffff80092ca7e2
            mov w2,wzr
            mov w3,wzr
            bl dev_err
.L_ffffff80089c0c0c:

            mov x0,x21
            bl mutex_unlock

            ldr w0,[x20,#744]
            mov x1,x19
            bl free_irq

            add x0,x19,#192
            bl cancel_work_sync

            ldr x0,[x19,#8]
            bl input_unregister_device

            add x0,x20,#32
            mov x1,x19
            bl devm_kfree

            ldp x20,x19,[sp,#32]
            ldr x21,[sp,#16]
            mov w0,wzr
            ldp fp,lr,[sp],#48
            ret
.size aw9523_i2c_remove, . - aw9523_i2c_remove
.align 4
#-----------------------------------
.globl aw9523_irq
.type aw9523_irq, @function
#-----------------------------------
aw9523_irq:

            stp fp,lr,[sp,#-48]!
            str x21,[sp,#16]
            stp x20,x19,[sp,#32]
            mov fp,sp
            ldr x21,[x1,#184]
            mov x19,x1
            add x20,x21,#48
            mov x0,x20
            bl mutex_lock

            mov w1,#6
            mov w2,#255
            mov x0,x19
            bl i2c_smbus_write_byte_data

            tbz w0,#31,.L_ffffff80089c0ca4

            adrp x1, .L_ffffff80092ca7e2
            mov w4,w0
            add x0,x19,#32
            add x1,x1, :lo12:.L_ffffff80092ca7e2
            mov w2,#255
            mov w3,#6
            bl dev_err
.L_ffffff80089c0ca4:

            mov x0,x20
            bl mutex_unlock

            ldr w0,[x19,#744]
            bl disable_irq_nosync

            adrp x8, system_wq
            ldr x1,[x8,:lo12:system_wq]
            add x2,x21,#192
            mov w0,#8
            bl queue_work_on

            ldp x20,x19,[sp,#32]
            ldr x21,[sp,#16]
            mov w0,#1
            ldp fp,lr,[sp],#48
            ret
.size aw9523_irq, . - aw9523_irq
.align 2
#-----------------------------------
.globl aw9523_key_work
.type aw9523_key_work, @function
#-----------------------------------
aw9523_key_work:

            sub sp,sp,#128
            stp fp,lr,[sp,#32]
            stp x28,x27,[sp,#48]
            stp x26,x25,[sp,#64]
            stp x24,x23,[sp,#80]
            stp x22,x21,[sp,#96]
            stp x20,x19,[sp,#112]
            add fp,sp,#32
            adrp x8, g_aw9523_data
            ldr x26,[x8,:lo12:g_aw9523_data]
            adrp x22, .L_ffffff80092ca810
            adrp x28, .L_ffffff800a24e760
            mov x19,xzr
            ldr x25,[x26]
            mov w20,#1
            add x22,x22, :lo12:.L_ffffff80092ca810
            add x28,x28, :lo12:.L_ffffff800a24e760
            add x27,x25,#32
            b .L_ffffff80089c0d48
.L_ffffff80089c0d28:

            mov w24,w3
.L_ffffff80089c0d2c:

            mov x0,x23
            bl mutex_unlock

            add x8,x28,x19
            strb w24,[x8,#8]
.L_ffffff80089c0d3c:

            add x19,x19,#1
            cmp x19,#8
            b.eq .L_ffffff80089c0de0
.L_ffffff80089c0d48:

            lsl w8,w20,w19
            ands w8,w8,#126
            b.eq .L_ffffff80089c0d3c

            ldr x9,[x25,#184]
            mov w21,w24
            eor w24,w8,#126
            add x23,x9,#48
            mov x0,x23
            bl mutex_lock

            mov w1,#5
            mov x0,x25
            mov w2,w24
            bl i2c_smbus_write_byte_data

            tbz w0,#31,.L_ffffff80089c0d9c

            adrp x1, .L_ffffff80092ca7e2
            mov w4,w0
            mov w3,#5
            mov x0,x27
            add x1,x1, :lo12:.L_ffffff80092ca7e2
            mov w2,w24
            bl dev_err
.L_ffffff80089c0d9c:

            mov x0,x23
            bl mutex_unlock

            ldr x8,[x25,#184]
            add x23,x8,#48
            mov x0,x23
            bl mutex_lock

            mov x0,x25
            mov w1,wzr
            bl i2c_smbus_read_byte_data

            mov w3,w0
            tbz w0,#31,.L_ffffff80089c0d28

            mov x0,x27
            mov x1,x22
            mov w2,wzr
            mov w24,w21
            bl dev_err

            b .L_ffffff80089c0d2c
.L_ffffff80089c0de0:

            ldp x9,x8,[x28]
            cmp x9,x8
            b.eq .L_ffffff80089c0f84

            str x27,[sp,#16]
            mov x20,xzr
            mov w23,wzr
            mov w27,#1
            mov w19,#28
            str w24,[sp,#12]
            stur x25,[fp,#-8]
.L_ffffff80089c0e08:

            and w10,w9,#255
            cmp w10,w8, uxtb
            b.ne .L_ffffff80089c0e34
.L_ffffff80089c0e14:

            add x20,x20,#1
            cmp x20,#8
            b.eq .L_ffffff80089c0f70

            add x8,x28,x20
            ldrb w9,[x8]
            ldrb w8,[x8,#8]
            mov w23,w20
            b .L_ffffff80089c0e08
.L_ffffff80089c0e34:

            add x10,x28,x20
            mov w24,wzr
            add x21,x10,#8
.L_ffffff80089c0e40:

            lsl w10,w27,w24
            eor w9,w8,w9
            and w9,w9,w10
            tst w9,#255
            b.eq .L_ffffff80089c0f58

            ldr w11,[x26,#112]
            ldr x9,[x26,#104]
            cmp w11,#1
            b.lt .L_ffffff80089c0ea8

            mov w25,wzr
            b .L_ffffff80089c0e7c
.L_ffffff80089c0e6c:

            add w12,w25,#1
            and w25,w12,#255
            cmp w11,w25
            b.le .L_ffffff80089c0eb0
.L_ffffff80089c0e7c:

            and x12,x25,#255
            madd x13,x12,x19,x9
            ldr w13,[x13,#20]
            cmp w13,w24
            b.ne .L_ffffff80089c0e6c

            madd x12,x12,x19,x9
            ldr w12,[x12,#24]
            cmp w12,w23
            b.ne .L_ffffff80089c0e6c

            mov w12,w25
            b .L_ffffff80089c0eb0
.L_ffffff80089c0ea8:

            mov w12,wzr
            mov w25,wzr
.L_ffffff80089c0eb0:

            and w8,w8,w10
            and x22,x12,#255
            tst w8,#255
            madd x8,x22,x19,x9
            add x8,x8,#16
            b.eq .L_ffffff80089c0ed0

            str wzr,[x8]
            b .L_ffffff80089c0eec
.L_ffffff80089c0ed0:

            str w27,[x8]
            adrp x8, .L_ffffff800a24f078
            ldr w8,[x8,:lo12:.L_ffffff800a24f078]
            cmp w8,#1
            b.ne .L_ffffff80089c0eec

            mov w0,#1
            # bl agold_touchpad_resume_suspend
.L_ffffff80089c0eec:

            ldr x8,[x26,#104]
            mul x22,x22,x19
            ldr x0,[x26,#8]
            mov w1,#1
            add x8,x8,x22
            ldp w2,w9,[x8,#12]
            cmp w9,#0
            cset w3,ne
            bl input_event

            ldr x0,[x26,#8]
            mov w1,wzr
            mov w2,wzr
            mov w3,wzr
            bl input_event

            ldr x8,[x26,#104]
            adrp x0, .L_ffffff80092d3449
            adrp x1, .L_ffffff8009192bec
            add x0,x0, :lo12:.L_ffffff80092d3449
            add x9,x8,x22
            ldp w5,w6,[x9,#12]
            ldp w7,w8,[x8,#20]
            add x1,x1, :lo12:.L_ffffff8009192bec
            mov w2,w25
            mov w3,w24
            mov w4,w23
            str w8,[sp]
            bl printk
.L_ffffff80089c0f58:

            add w24,w24,#1
            cmp w24,#8
            b.eq .L_ffffff80089c0e14

            ldrb w9,[x28,x20]
            ldrb w8,[x21]
            b .L_ffffff80089c0e40
.L_ffffff80089c0f70:

            adrp x8, .L_ffffff800a24e768
            ldr x9,[x8,:lo12:.L_ffffff800a24e768]
            ldur x25,[fp,#-8]
            ldr x27,[sp,#16]
            ldr w24,[sp,#12]
.L_ffffff80089c0f84:

            adrp x10, .L_ffffff800a24e778
            add x10,x10, :lo12:.L_ffffff800a24e778
            ldr x8,[x28,#8]
            ldr x10,[x10]
            str x9,[x28]
            cmp x8,x10
            b.ne .L_ffffff80089c1084

            ldr x8,[x25,#184]
            add x21,x8,#48
            mov x0,x21
            bl mutex_lock

            mov w1,#5
            mov x0,x25
            mov w2,wzr
            bl i2c_smbus_write_byte_data

            tbz w0,#31,.L_ffffff80089c0fe0

            adrp x1, .L_ffffff80092ca7e2
            mov w4,w0
            add x1,x1, :lo12:.L_ffffff80092ca7e2
            mov w2,#-256
            mov w3,#5
            mov x0,x27
            bl dev_err
.L_ffffff80089c0fe0:

            mov x0,x21
            bl mutex_unlock

            ldr x8,[x25,#184]
            add x21,x8,#48
            mov x0,x21
            bl mutex_lock

            mov w1,#1
            mov x0,x25
            bl i2c_smbus_read_byte_data

            mov w3,w0
            tbnz w0,#31,.L_ffffff80089c1014

            mov w24,w3
            b .L_ffffff80089c1028
.L_ffffff80089c1014:

            adrp x1, .L_ffffff80092ca810
            add x1,x1, :lo12:.L_ffffff80092ca810
            mov w2,#1
            mov x0,x27
            bl dev_err
.L_ffffff80089c1028:

            mov x0,x21
            bl mutex_unlock

            ldr x8,[x25,#184]
            add x21,x8,#48
            mov x0,x21
            bl mutex_lock

            mov x0,x25
            mov w1,wzr
            bl i2c_smbus_read_byte_data

            mov w3,w0
            tbnz w0,#31,.L_ffffff80089c105c

            mov w24,w3
            b .L_ffffff80089c1070
.L_ffffff80089c105c:

            adrp x1, .L_ffffff80092ca810
            add x1,x1, :lo12:.L_ffffff80092ca810
            mov x0,x27
            mov w2,wzr
            bl dev_err
.L_ffffff80089c1070:

            mov x0,x21
            bl mutex_unlock

            mvn w8,w24
            tst w8,#255
            b.eq .L_ffffff80089c10bc
.L_ffffff80089c1084:

            mov w1,#58208
            add x0,x26,#128
            movk w1,#22,lsl #16
            mov w3,#1
            mov x2,xzr
            bl hrtimer_start_range_ns
.L_ffffff80089c109c:

            ldp x20,x19,[sp,#112]
            ldp x22,x21,[sp,#96]
            ldp x24,x23,[sp,#80]
            ldp x26,x25,[sp,#64]
            ldp x28,x27,[sp,#48]
            ldp fp,lr,[sp,#32]
            add sp,sp,#128
            ret
.L_ffffff80089c10bc:

            ldr x8,[x25,#184]
            add x21,x8,#48
            mov x0,x21
            bl mutex_lock

            mov w1,#6
            mov x0,x25
            mov w2,wzr
            bl i2c_smbus_write_byte_data

            tbz w0,#31,.L_ffffff80089c10fc

            adrp x1, .L_ffffff80092ca7e2
            mov w4,w0
            add x1,x1, :lo12:.L_ffffff80092ca7e2
            mov w2,#-256
            mov w3,#6
            mov x0,x27
            bl dev_err
.L_ffffff80089c10fc:

            mov x0,x21
            bl mutex_unlock

            adrp x8, .L_ffffff800a24f078
            ldr w8,[x8,:lo12:.L_ffffff800a24f078]
            cmp w8,#1
            b.ne .L_ffffff80089c111c

            mov w0,wzr
            # bl agold_touchpad_resume_suspend
.L_ffffff80089c111c:

            ldr w0,[x25,#744]
            bl enable_irq

            adrp x0, .L_ffffff80093373fe
            add x0,x0, :lo12:.L_ffffff80093373fe
            bl printk

            b .L_ffffff80089c109c
.size aw9523_key_work, . - aw9523_key_work
.align 2
#-----------------------------------
.globl aw9523_key_timer_func
.type aw9523_key_timer_func, @function
#-----------------------------------
aw9523_key_timer_func:

            stp fp,lr,[sp,#-16]!
            mov fp,sp
            adrp x8, g_aw9523_data
            ldr x8,[x8,:lo12:g_aw9523_data]
            adrp x9, system_wq
            ldr x1,[x9,:lo12:system_wq]
            mov w0,#8
            add x2,x8,#192
            bl queue_work_on

            mov w0,wzr
            ldp fp,lr,[sp],#16
            ret
.size aw9523_key_timer_func, . - aw9523_key_timer_func
.align 2
#-----------------------------------
.type key_fb_notifier_callback, @function
#-----------------------------------
key_fb_notifier_callback:

            stp fp,lr,[sp,#-16]!
            mov fp,sp
            cmp x1,#9
            b.ne .L_ffffff80089c1194

            ldr x8,[x2,#8]
            ldr w8,[x8]
            cmp w8,#4
            b.eq .L_ffffff80089c1190

            cbnz w8,.L_ffffff80089c1194

            bl agold_key_resume

            b .L_ffffff80089c1194
.L_ffffff80089c1190:

            bl agold_key_suspend
.L_ffffff80089c1194:

            mov w0,wzr
            ldp fp,lr,[sp],#16
            ret
.size key_fb_notifier_callback, . - key_fb_notifier_callback
.align 4
#-----------------------------------
.type aw9523_get_reg, @function
#-----------------------------------
aw9523_get_reg:

            stp fp,lr,[sp,#-96]!
            stp x28,x27,[sp,#16]
            stp x26,x25,[sp,#32]
            stp x24,x23,[sp,#48]
            stp x22,x21,[sp,#64]
            stp x20,x19,[sp,#80]
            mov fp,sp
            adrp x8, g_aw9523_data
            ldr x8,[x8,:lo12:g_aw9523_data]
            adrp x23, .L_ffffff80092ca810
            adrp x25, .L_ffffff800920f7c6
            mov x20,x2
            ldr x22,[x8]
            mov w21,wzr
            mov x19,xzr
            add x23,x23, :lo12:.L_ffffff80092ca810
            mov w27,#4096
            add x24,x22,#32
            add x25,x25, :lo12:.L_ffffff800920f7c6
            b .L_ffffff80089c1224
.L_ffffff80089c11f0:

            mov w28,w3
.L_ffffff80089c11f4:

            mov x0,x26
            bl mutex_unlock

            add x0,x20,x19
            sub x1,x27,x19
            and w4,w28,#255
            mov x2,x25
            mov w3,w21
            bl snprintf

            add w21,w21,#1
            cmp w21,#48
            add x19,x19,w0, sxtw
            b.eq .L_ffffff80089c125c
.L_ffffff80089c1224:

            ldr x8,[x22,#184]
            add x26,x8,#48
            mov x0,x26
            bl mutex_lock

            mov x0,x22
            mov w1,w21
            bl i2c_smbus_read_byte_data

            mov w3,w0
            tbz w0,#31,.L_ffffff80089c11f0

            mov x0,x24
            mov x1,x23
            mov w2,w21
            bl dev_err

            b .L_ffffff80089c11f4
.L_ffffff80089c125c:

            mov x0,x19
            ldp x20,x19,[sp,#80]
            ldp x22,x21,[sp,#64]
            ldp x24,x23,[sp,#48]
            ldp x26,x25,[sp,#32]
            ldp x28,x27,[sp,#16]
            ldp fp,lr,[sp],#96
            ret
.size aw9523_get_reg, . - aw9523_get_reg
.align 2
#-----------------------------------
.type aw9523_set_reg, @function
#-----------------------------------
aw9523_set_reg:

            sub sp,sp,#80
            stp fp,lr,[sp,#16]
            str x23,[sp,#32]
            stp x22,x21,[sp,#48]
            stp x20,x19,[sp,#64]
            add fp,sp,#16
            adrp x8, __stack_chk_guard
            ldr x8,[x8,:lo12:__stack_chk_guard]
            adrp x1, .L_ffffff800915f595
            mov x19,x3
            mov x0,x2
            str x8,[sp,#8]
            adrp x8, g_aw9523_data
            ldr x8,[x8,:lo12:g_aw9523_data]
            add x1,x1, :lo12:.L_ffffff800915f595
            mov x2,sp
            ldr x20,[x8]
            mov x8,sp
            add x3,x8,#4
            bl sscanf

            cmp w0,#2
            b.ne .L_ffffff80089c1320

            ldr x8,[x20,#184]
            ldp w22,w23,[sp]
            add x21,x8,#48
            mov x0,x21
            bl mutex_lock

            mov x0,x20
            mov w1,w22
            mov w2,w23
            bl i2c_smbus_write_byte_data

            tbz w0,#31,.L_ffffff80089c1318

            adrp x1, .L_ffffff80092ca7e2
            mov w4,w0
            add x0,x20,#32
            add x1,x1, :lo12:.L_ffffff80092ca7e2
            mov w2,w23
            mov w3,w22
            bl dev_err
.L_ffffff80089c1318:

            mov x0,x21
            bl mutex_unlock
.L_ffffff80089c1320:

            adrp x9, __stack_chk_guard
            ldr x8,[sp,#8]
            ldr x9,[x9,:lo12:__stack_chk_guard]
            cmp x9,x8
            b.ne .L_ffffff80089c1350

            mov x0,x19
            ldp x20,x19,[sp,#64]
            ldp x22,x21,[sp,#48]
            ldr x23,[sp,#32]
            ldp fp,lr,[sp,#16]
            add sp,sp,#80
            ret
.L_ffffff80089c1350:

            bl __stack_chk_fail
.size aw9523_set_reg, . - aw9523_set_reg

#===================================
.section .data
#===================================
.align 3
.L_ffffff800915b958:
          .string "bpf_skb_get_tunnel_key"
.L_ffffff800915b96f:
          .ascii "size_"
.L_ffffff800915b974:
          .string "key"
.L_ffffff800915b978:
          .string "pkcs7_find_key"
.L_ffffff800915b987:
          .string "find_asymmetric_key"
.L_ffffff800915b99b:
          .string "public_key"
.L_ffffff800915b9a6:
          .string "mediatek,kpd-hw-factory-key"
.L_ffffff800915b9c2:
          .string "mediatek,kpd-hw-recovery-key"
.L_ffffff800915b9df:
          .string "default-key"
.L_ffffff800915b9eb:
          .string "aw9523-key"
.L_ffffff800915b9f6:
          .string "plat_dbg_info,key"
.L_ffffff800915ba08:
          .string "Siphash requires key"
.L_ffffff800915ba1d:
          .string "Error initializing blk-crypto key"
.L_ffffff800915ba3f:
          .string "error %d initializing blk-crypto key"
.L_ffffff800915ba64:
          .ascii "Error decoding and setting "
.L_ffffff800915f514:
          .ascii " cap_fe=%d cap_"
.L_ffffff800915f523:
          .string "fver=%x"
.L_ffffff800915f52b:
          .string "%x:%x"
.L_ffffff800915f531:
          .string "PRODUCT=%x/%x/%x"
.L_ffffff800915f542:
          .ascii "PRODUCT=%x/%x/%x/"
.L_ffffff800915f553:
          .string "%x"
.L_ffffff800915f556:
          .ascii "%x-%x-"
.L_ffffff800915f55c:
          .string "%x-%x"
.L_ffffff800915f562:
          .string "#%x"
.L_ffffff800915f566:
          .string "%x %x %x %x %x %x %x %x %x"
.L_ffffff800915f581:
          .ascii "%31s %x %x "
.L_ffffff800915f58c:
          .ascii "%x "
.L_ffffff800915f58f:
          .ascii "%x "
.L_ffffff800915f592:
          .ascii "%x "
.L_ffffff800915f595:
          .string "%x %x"
.L_ffffff800915f59b:
          .string "%x %x %x %x %u %x"
.L_ffffff800915f5ad:
          .string "%127s %x"
.L_ffffff800915f5b6:
          .string "%63s %x"
.L_ffffff800915f5be:
          .string "%31s %10s %x"
.L_ffffff800915f5cb:
          .byte 0x1
          .byte 0x36
          .byte 0x25
          .byte 0x73
          .byte 0x20
          .byte 0x77
          .byte 0x69
          .byte 0x74
          .byte 0x68
          .byte 0x6f
          .byte 0x75
          .byte 0x74
          .byte 0x20
          .byte 0x63
          .byte 0x68
          .byte 0x61
          .byte 0x6e
          .byte 0x67
          .byte 0x65
          .byte 0x20
          .byte 0x6d
          .byte 0x6f
          .byte 0x64
          .byte 0x65
          .byte 0x20
          .byte 0x73
          .byte 0x65
          .byte 0x74
          .byte 0x74
          .byte 0x69
          .byte 0x6e
          .byte 0x67
          .byte 0x20
          .byte 0x25
          .byte 0x78
          .byte 0x0
.L_ffffff800915f5ef:
          .byte 0x1
          .byte 0x36
          .byte 0x25
          .byte 0x73
          .byte 0x20
          .byte 0x77
          .byte 0x69
          .byte 0x74
          .byte 0x68
          .byte 0x6f
          .byte 0x75
          .byte 0x74
          .byte 0x20
          .byte 0x63
          .byte 0x68
          .byte 0x61
          .byte 0x6e
          .byte 0x67
          .byte 0x65
          .byte 0x20
          .byte 0x6d
          .byte 0x6f
          .byte 0x64
          .byte 0x65
          .byte 0x20
          .byte 0x25
          .byte 0x78
          .byte 0x0
.L_ffffff800915f60b:
          .string "Unknown GPU ID %x"
.L_ffffff800915fa9e:
          .string "pcm_dl2_copy - underflow"
.L_ffffff800915fab7:
          .string "mt6370_toggle_chgdet_flow"
.L_ffffff800915fad1:
          .ascii "__"
.L_ffffff800915fad3:
          .string "mt6370_enable_chgdet_flow"
.L_ffffff800915faed:
          .string "buffer_over_flow"
.L_ffffff800915fafe:
          .string "use_hp_depop_flow"
.L_ffffff800915fb10:
          .string "finger_rst_low"
.L_ffffff800915fb1f:
          .string "aw9523_reset_low"
.L_ffffff800915fb30:
          .string "drvvbus_low"
.L_ffffff800915fb3c:
          .string "finger_power_low"
.L_ffffff800915fb4d:
          .string "fg_compensate_battery_voltage_from_low"
.L_ffffff800915fb74:
          .string "aud_clk_mosi_pull_low"
.L_ffffff800915fb8a:
          .string "rssi_low"
.L_ffffff800915fb93:
          .string "gpiod_is_active_low"
.L_ffffff800915fba7:
          .string "ps_threshold_low"
.L_ffffff800916800a:
          .string "affinity_hint"
.L_ffffff8009168018:
          .string "sched_isolation_hint"
.L_ffffff800916802d:
          .ascii "ksched_"
.L_ffffff8009168034:
          .string "hint"
.L_ffffff8009168039:
          .string "primary_display_request_eint"
.L_ffffff8009168056:
          .ascii "clear_"
.L_ffffff800916805c:
          .string "accdet_eint"
.L_ffffff8009168068:
          .string "finger_eint"
.L_ffffff8009168074:
          .string "reg_base_eint"
.L_ffffff8009168082:
          .string "usbcd_eint"
.L_ffffff800916808d:
          .string "aw9523_eint"
.L_ffffff8009168099:
          .ascii "mediatek, "
.L_ffffff80091680a3:
          .string "mrdump_ext_rst-eint"
.L_ffffff80091680b7:
          .string "mt-eint"
.L_ffffff80091680bf:
          .string "mediatek,irq_nfc-eint"
.L_ffffff80091680d5:
          .string "TOUCH_PANEL-eint"
.L_ffffff80091680e6:
          .string "WIFI-eint"
.L_ffffff80091680f0:
          .ascii "mediatek, "
.L_ffffff80091680fa:
          .string "DSI_TE-eint"
.L_ffffff8009168106:
          .string "swtp1-eint"
.L_ffffff8009168111:
          .ascii "swtp0-"
.L_ffffff8009168117:
          .string "eint"
.L_ffffff8009182414:
          .string "wdt_enable_irq"
.L_ffffff8009182423:
          .string "ccif_enable_irq"
.L_ffffff8009182433:
          .string "mt6370_enable_irq"
.L_ffffff8009182445:
          .string "sf_ctl_device_irq"
.L_ffffff8009182457:
          .string "testcase_nonsuspend_irq"
.L_ffffff800918246f:
          .string "msdc_irq"
.L_ffffff8009182478:
          .string "hub_irq"
.L_ffffff8009182480:
          .string "seq_rdma_irq"
.L_ffffff800918248d:
          .string "mtu3_irq"
.L_ffffff8009182496:
          .string "aw9523_irq"
.L_ffffff80091824a1:
          .string "trusty-irq"
.L_ffffff80091824ac:
          .string "cap-sdio-irq"
.L_ffffff80091824b9:
          .string "sf-irq"
.L_ffffff80091824c0:
          .string "nebula-irq"
.L_ffffff80091824cb:
          .string "mt6358-irq"
.L_ffffff80091824d6:
          .string "stray irq"
.L_ffffff80091824e0:
          .string "mt6370 dsv irq"
.L_ffffff80091824ef:
          .string "mtk btif irq"
.L_ffffff80091824fc:
          .string "mtk btif tx dma irq"
.L_ffffff8009182510:
          .ascii "mtk btif rx dma "
.L_ffffff8009182520:
          .string "irq"
.L_ffffff800918654a:
          .string "lcm1_rst_out1_gpio"
.L_ffffff800918655d:
          .string "lcd_bias_enp1_gpio"
.L_ffffff8009186570:
          .string "lcm_rst_out0_gpio"
.L_ffffff8009186582:
          .string "lcm1_rst_out0_gpio"
.L_ffffff8009186595:
          .string "lcd_bias_enp0_gpio"
.L_ffffff80091865a8:
          .string "tpd-use-ext-gpio"
.L_ffffff80091865b9:
          .string "rst-gpio"
.L_ffffff80091865c2:
          .string "int-gpio"
.L_ffffff80091865cb:
          .ascii "awinic,"
.L_ffffff80091865d2:
          .string "reset-gpio"
.L_ffffff80091865dd:
          .string "i2s3dat-gpio"
.L_ffffff80091865ea:
          .string "i2s2dat-gpio"
.L_ffffff80091865f7:
          .string "i2s1dat-gpio"
.L_ffffff8009186604:
          .string "i2s0dat-gpio"
.L_ffffff8009186611:
          .string "i2s3ws-gpio"
.L_ffffff800918661d:
          .string "i2s2ws-gpio"
.L_ffffff8009186629:
          .string "i2s1ws-gpio"
.L_ffffff8009186635:
          .string "i2s0ws-gpio"
.L_ffffff8009186641:
          .ascii "awinic,"
.L_ffffff8009186648:
          .string "irq-gpio"
.L_ffffff8009186651:
          .string "i2s0datain-gpio"
.L_ffffff8009186661:
          .string "i2s3mclk-gpio"
.L_ffffff800918666f:
          .string "i2s2mclk-gpio"
.L_ffffff800918667d:
          .string "i2s1mclk-gpio"
.L_ffffff800918668b:
          .string "i2s0mclk-gpio"
.L_ffffff8009186699:
          .string "audclk-gpio"
.L_ffffff80091866a5:
          .string "i2s3clk-gpio"
.L_ffffff80091866b2:
          .string "i2s2clk-gpio"
.L_ffffff80091866bf:
          .string "i2s1clk-gpio"
.L_ffffff80091866cc:
          .string "i2s0clk-gpio"
.L_ffffff8009192b66:
          .string "csr-mask"
.L_ffffff8009192b6f:
          .string "interrupt-map-mask"
.L_ffffff8009192b82:
          .string "enable-mask"
.L_ffffff8009192b8e:
          .ascii "WRITE_S"
.L_ffffff8009192b95:
          .ascii " with "
.L_ffffff8009192b9b:
          .string "mask"
.L_ffffff8009192ba0:
          .string "ISP_Halt_Mask"
.L_ffffff8009192bae:
          .string "IEC958 Playback Mask"
.L_ffffff8009192bc3:
          .string "always_check_network"
.L_ffffff8009192bd8:
          .string "usb_stor_scan_dwork"
.L_ffffff8009192bec:
          .string "aw9523_key_work"
.L_ffffff8009192bfc:
          .string "md_ccif_sram_rx_work"
.L_ffffff8009192c11:
          .string "ccci_scp_ipi_rx_work"
.L_ffffff8009192c26:
          .string "ccif_rx_work"
.L_ffffff8009192c33:
          .string "cmdq_thread_handle_timeout_work"
.L_ffffff8009192c53:
          .string "crda_timeout_work"
.L_ffffff8009192c65:
          .string "btif_log_buf_dmp_out_work"
.L_ffffff8009194d70:
          .string "&tcpc_otg_lock"
.L_ffffff8009194d7f:
          .string "&ctx->ring_lock"
.L_ffffff8009194d8f:
          .string "&hba->clk_scaling_lock"
.L_ffffff8009194da6:
          .string "&chg_data->tchg_lock"
.L_ffffff8009194dbb:
          .string "&kctx->reg_lock"
.L_ffffff8009194dcb:
          .string "&kbdev->dma_buf_lock"
.L_ffffff8009194de0:
          .string "&buff_lock"
.L_ffffff8009194deb:
          .string "&poweroff_lock"
.L_ffffff8009194dfa:
          .string "&pdata->read_write_lock"
.L_ffffff8009194e12:
          .string "&tty->atomic_write_lock"
.L_ffffff8009194e2a:
          .string "&attr_set->update_lock"
.L_ffffff8009194e41:
          .string "&ei->truncate_lock"
.L_ffffff8009194e54:
          .string "&md->type_lock"
.L_ffffff8009194e63:
          .string "scp_awake_lock"
.L_ffffff8009194e72:
          .string "ps_wake_lock"
.L_ffffff8009194e7f:
          .string "wakeup_wake_lock"
.L_ffffff8009194e90:
          .string "cmdq_lock_wake_lock"
.L_ffffff8009198467:
          .string "perf buffer not large enough"
.L_ffffff8009198484:
          .string "profile buffer not large enough"
.L_ffffff80091984a4:
          .string "hpdepop-pullhigh"
.L_ffffff80091984b5:
          .string "extamp-pullhigh"
.L_ffffff80091984c5:
          .string "rcvspk-pullhigh"
.L_ffffff80091984d5:
          .string "extamp2-pullhigh"
.L_ffffff80091984e6:
          .string "finger_rst_high"
.L_ffffff80091984f6:
          .string "aw9523_reset_high"
.L_ffffff8009198508:
          .string "drvvbus_high"
.L_ffffff8009198515:
          .string "finger_power_high"
.L_ffffff8009198527:
          .string "aud_clk_mosi_pull_high"
.L_ffffff800919853e:
          .string "rssi_high"
.L_ffffff8009198548:
          .string "ps_threshold_high"
.L_ffffff800919855a:
          .string "/high"
.L_ffffff8009198560:
          .string "output-high"
.L_ffffff800919856c:
          .string "spi-cs-high"
.L_ffffff8009198578:
          .ascii "Chunk size is too"
.L_ffffff800919cb23:
          .string "aarch64_insn_gen_add_sub_shifted_reg"
.L_ffffff800919cb48:
          .string "read_reg"
.L_ffffff800919cb51:
          .string "codec_reg"
.L_ffffff800919cb5b:
          .ascii "hal_"
.L_ffffff800919cb5f:
          .string "btif_rx_cb_reg"
.L_ffffff800919cb6e:
          .string "hal_btif_dma_rx_cb_reg"
.L_ffffff800919cb85:
          .string "testcase_read_to_data_reg"
.L_ffffff800919cb9f:
          .string "testcase_write_from_data_reg"
.L_ffffff800919cbbc:
          .string "aw9523_reg"
.L_ffffff800919cbc7:
          .string "div-reg"
.L_ffffff800919cbcf:
          .ascii "custom-"
.L_ffffff800919cbd6:
          .string "reg"
.L_ffffff800919cbda:
          .string "mtk_jpeg"
.L_ffffff800919cbe3:
          .ascii "mt6370_"
.L_ffffff800919cbea:
          .ascii "dsv_"
.L_ffffff800919cbee:
          .string "neg"
.L_ffffff800919cbf2:
          .string "int_deg"
.L_ffffff800919cbfa:
          .string "SetMemIfFormatReg"
.L_ffffff800919cc0c:
          .string "WPE_DumpReg"
.L_ffffff800919cc18:
          .string "GetBufferCtrlReg"
.L_ffffff800919cc29:
          .string "ISP_WriteReg"
.L_ffffff800919cc36:
          .string "s4AF_WriteReg"
.L_ffffff800919cc44:
          .string "s4AK7372AF_WriteReg"
.L_ffffff80091b091c:
          .string "mt635x_auxadc_probe"
.L_ffffff80091b0930:
          .string "mt_auxadc_probe"
.L_ffffff80091b0940:
          .string "acc_probe"
.L_ffffff80091b094a:
          .string "step_c_probe"
.L_ffffff80091b0957:
          .string "mt_i2c_probe"
.L_ffffff80091b0964:
          .string "fsm_i2c_probe"
.L_ffffff80091b0972:
          .string "mtk_spk_i2c_probe"
.L_ffffff80091b0984:
          .string "tpd_i2c_probe"
.L_ffffff80091b0992:
          .string "AF_i2c_probe"
.L_ffffff80091b099f:
          .string "aw9523_i2c_probe"
.L_ffffff80091b09b0:
          .string "asw5480_i2c_probe"
.L_ffffff80091b09c2:
          .string "mt6370_i2c_probe"
.L_ffffff80091b09d3:
          .string "mtk_mrgrx_awb_probe"
.L_ffffff80091b09e7:
          .string "mtk_afe_mrgrx_awb_probe"
.L_ffffff80091b09ff:
          .string "mtk_fm_i2s_awb_probe"
.L_ffffff80091b0a14:
          .string "mtk_dl1_awb_probe"
.L_ffffff80091b0a26:
          .string "mtk_afe_dl1_awb_probe"
.L_ffffff80091f107d:
          .ascii "mdp_"
.L_ffffff80091f1081:
          .string "rsz0"
.L_ffffff80091f1086:
          .ascii "rawbulk-"
.L_ffffff80091f108e:
          .string "dummy0"
.L_ffffff80091f1095:
          .string "mediatek,mipi_tx0"
.L_ffffff80091f10a7:
          .ascii "Mute"
.L_ffffff80091f10ab:
          .string "x0"
.L_ffffff80091f10ae:
          .string "camsys_camsv0"
.L_ffffff80091f10bc:
          .ascii "jqfmt="
.L_ffffff80091f10c2:
          .string "vfsv0"
.L_ffffff80091f10c8:
          .ascii " "
.L_ffffff80091f10c9:
          .string "wrappedkey_v0"
.L_ffffff80091f10d7:
          .string "vpu0"
.L_ffffff80091f10dc:
          .string "state_rst_output0"
.L_ffffff80091f10ee:
          .string "state_eint_output0"
.L_ffffff80091f1101:
          .ascii "aw9523-keys"
.L_ffffff80091f110c:
          .string "/input0"
.L_ffffff80091f1114:
          .string "rst0"
.L_ffffff80091f1119:
          .ascii "type_c_"
.L_ffffff80091f1120:
          .string "port0"
.L_ffffff80091f1126:
          .ascii "infra_"
.L_ffffff80091f112c:
          .string "uart0"
.L_ffffff80091f1132:
          .ascii "mm_"
.L_ffffff80091f1135:
          .string "mdp_wrot0"
.L_ffffff80091f113f:
          .string "mmcqd/0boot0"
.L_ffffff80091f114c:
          .ascii "ctl_"
.L_ffffff80091f1150:
          .string "int0"
.L_ffffff80091f1155:
          .string "sit0"
.L_ffffff80091f115a:
          .string "fsm_scp_init0"
.L_ffffff80091f1168:
          .string "lcm0_reset0"
.L_ffffff80091f1174:
          .string "dat0"
.L_ffffff80091f1179:
          .string "mtk_soc_pcm_dl1_i2s0"
.L_ffffff8009201daa:
          .string "[PLAT DBG INFO] cannot allocate memory\n"
.L_ffffff8009201dd2:
          .byte 0x1
          .byte 0x36
          .byte 0x5b
          .byte 0x42
          .byte 0x4f
          .byte 0x4f
          .byte 0x54
          .byte 0x50
          .byte 0x52
          .byte 0x4f
          .byte 0x46
          .byte 0x5d
          .byte 0x20
          .byte 0x66
          .byte 0x61
          .byte 0x69
          .byte 0x6c
          .byte 0x20
          .byte 0x74
          .byte 0x6f
          .byte 0x20
          .byte 0x61
          .byte 0x6c
          .byte 0x6c
          .byte 0x6f
          .byte 0x63
          .byte 0x61
          .byte 0x74
          .byte 0x65
          .byte 0x20
          .byte 0x6d
          .byte 0x65
          .byte 0x6d
          .byte 0x6f
          .byte 0x72
          .byte 0x79
          .byte 0xa
          .byte 0x0
.L_ffffff8009201df8:
          .string "%s: unable to allocate memory\n"
.L_ffffff8009201e17:
          .byte 0x1
          .byte 0x34
          .byte 0x25
          .byte 0x73
          .byte 0x20
          .byte 0x66
          .byte 0x61
          .byte 0x69
          .byte 0x6c
          .byte 0x65
          .byte 0x64
          .byte 0x20
          .byte 0x74
          .byte 0x6f
          .byte 0x20
          .byte 0x61
          .byte 0x6c
          .byte 0x6c
          .byte 0x6f
          .byte 0x63
          .byte 0x61
          .byte 0x74
          .byte 0x65
          .byte 0x20
          .byte 0x6d
          .byte 0x65
          .byte 0x6d
          .byte 0x6f
          .byte 0x72
          .byte 0x79
          .byte 0xa
          .byte 0x0
.L_ffffff8009201e37:
          .ascii "ASoC: "
.L_ffffff8009201e3d:
          .string "Failed to allocate memory\n"
.L_ffffff8009201e58:
          .byte 0x1
          .byte 0x36
.L_ffffff8009201e5a:
          .string "[ccci%d/mcd]Dump exception share memory\n"
.L_ffffff8009201e83:
          .string "[%d]Dump exception share memory\n"
.L_ffffff8009201ea4:
          .byte 0x1
          .byte 0x36
.L_ffffff8009201ea6:
          .string "[ccci%d/mcd]Dump DHL RAW share memory\n"
.L_ffffff8009201ecd:
          .string "[%d]Dump DHL RAW share memory\n"
.L_ffffff800920f744:
          .byte 0x1
          .byte 0x37
          .byte 0x6b
          .byte 0x65
          .byte 0x79
          .byte 0x62
          .byte 0x6f
          .byte 0x61
          .byte 0x72
          .byte 0x64
          .byte 0x3a
          .byte 0x20
          .byte 0x6b
          .byte 0x65
          .byte 0x79
          .byte 0x64
          .byte 0x61
          .byte 0x74
          .byte 0x61
          .byte 0x20
          .byte 0x3d
          .byte 0x20
          .byte 0x30
          .byte 0x78
          .byte 0x25
          .byte 0x30
          .byte 0x32
          .byte 0x78
          .byte 0x2c
          .byte 0x20
          .byte 0x73
          .byte 0x68
          .byte 0x69
          .byte 0x66
          .byte 0x74
          .byte 0x6d
          .byte 0x61
          .byte 0x73
          .byte 0x6b
          .byte 0x20
          .byte 0x3d
          .byte 0x20
          .byte 0x30
          .byte 0x78
          .byte 0x25
          .byte 0x30
          .byte 0x32
          .byte 0x78
          .byte 0xa
          .byte 0x0
.L_ffffff800920f776:
          .string "%s: Flash status = %d, command = 0x%02x\n"
.L_ffffff800920f79f:
          .string "%s: Interrupt enable mask %d = 0x%02x\n"
.L_ffffff800920f7c6:
          .string "reg[0x%02x] = 0x%02x\n"
.L_ffffff800920f7dc:
          .string "<<GTP-INF>>[%s:%d] X_MAX = %d, Y_MAX = %d, TRIGGER = 0x%02x\n"
.L_ffffff800920f819:
          .string "%s: Supported partitions: 0x%02x\n"
.L_ffffff800920f83b:
          .string "%s: 0x%02x\n"
.L_ffffff800920f847:
          .byte 0x1
          .byte 0x36
          .byte 0x25
          .byte 0x73
          .byte 0x3a
          .byte 0x25
          .byte 0x64
          .byte 0x3a
          .byte 0x20
          .byte 0x25
          .byte 0x73
          .byte 0x20
          .byte 0x61
          .byte 0x64
          .byte 0x64
          .byte 0x72
          .byte 0x3a
          .byte 0x20
          .byte 0x30
          .byte 0x78
          .byte 0x25
          .byte 0x30
          .byte 0x32
          .byte 0x78
          .byte 0xa
          .byte 0x0
.L_ffffff80092526b9:
          .byte 0x1
          .byte 0x33
          .byte 0x5b
          .byte 0x47
          .byte 0x73
          .byte 0x65
          .byte 0x6e
          .byte 0x73
          .byte 0x6f
          .byte 0x72
          .byte 0x5d
          .byte 0x20
          .byte 0x61
          .byte 0x63
          .byte 0x63
          .byte 0x65
          .byte 0x6c
          .byte 0x20
          .byte 0x70
          .byte 0x6c
          .byte 0x61
          .byte 0x74
          .byte 0x66
          .byte 0x6f
          .byte 0x72
          .byte 0x6d
          .byte 0x20
          .byte 0x64
          .byte 0x65
          .byte 0x76
          .byte 0x69
          .byte 0x63
          .byte 0x65
          .byte 0x20
          .byte 0x65
          .byte 0x72
          .byte 0x72
          .byte 0x6f
          .byte 0x72
          .byte 0xa
          .byte 0x0
.L_ffffff80092526e2:
          .byte 0x1
          .byte 0x33
          .byte 0x5b
          .byte 0x73
          .byte 0x65
          .byte 0x6e
          .byte 0x73
          .byte 0x6f
          .byte 0x72
          .byte 0x48
          .byte 0x75
          .byte 0x62
          .byte 0x5d
          .byte 0x20
          .byte 0x53
          .byte 0x43
          .byte 0x50
          .byte 0x5f
          .byte 0x73
          .byte 0x65
          .byte 0x6e
          .byte 0x73
          .byte 0x6f
          .byte 0x72
          .byte 0x48
          .byte 0x75
          .byte 0x62
          .byte 0x20
          .byte 0x70
          .byte 0x6c
          .byte 0x61
          .byte 0x74
          .byte 0x66
          .byte 0x6f
          .byte 0x72
          .byte 0x6d
          .byte 0x20
          .byte 0x64
          .byte 0x65
          .byte 0x76
          .byte 0x69
          .byte 0x63
          .byte 0x65
          .byte 0x20
          .byte 0x65
          .byte 0x72
          .byte 0x72
          .byte 0x6f
          .byte 0x72
          .byte 0xa
          .byte 0x0
.L_ffffff8009252715:
          .byte 0x1
          .byte 0x33
          .byte 0x5b
          .byte 0x4d
          .byte 0x73
          .byte 0x65
          .byte 0x6e
          .byte 0x73
          .byte 0x6f
          .byte 0x72
          .byte 0x5d
          .byte 0x20
          .byte 0x70
          .byte 0x6c
          .byte 0x61
          .byte 0x74
          .byte 0x66
          .byte 0x6f
          .byte 0x72
          .byte 0x6d
          .byte 0x20
          .byte 0x64
          .byte 0x65
          .byte 0x76
          .byte 0x69
          .byte 0x63
          .byte 0x65
          .byte 0x20
          .byte 0x65
          .byte 0x72
          .byte 0x72
          .byte 0x6f
          .byte 0x72
          .byte 0xa
          .byte 0x0
.L_ffffff8009252738:
          .byte 0x1
          .byte 0x33
          .byte 0x5b
          .byte 0x47
          .byte 0x59
          .byte 0x52
          .byte 0x4f
          .byte 0x5d
          .byte 0x20
          .byte 0x70
          .byte 0x6c
          .byte 0x61
          .byte 0x74
          .byte 0x66
          .byte 0x6f
          .byte 0x72
          .byte 0x6d
          .byte 0x20
          .byte 0x64
          .byte 0x65
          .byte 0x76
          .byte 0x69
          .byte 0x63
          .byte 0x65
          .byte 0x20
          .byte 0x65
          .byte 0x72
          .byte 0x72
          .byte 0x6f
          .byte 0x72
          .byte 0xa
          .byte 0x0
.L_ffffff8009252758:
          .string "%s: read_chipid error\n"
.L_ffffff800925276f:
          .string "PPP: VJ uncompressed error\n"
.L_ffffff800925278b:
          .byte 0x1
          .byte 0x33
          .byte 0x5b
          .byte 0x73
          .byte 0x65
          .byte 0x6e
          .byte 0x73
          .byte 0x6f
          .byte 0x72
          .byte 0x48
          .byte 0x75
          .byte 0x62
          .byte 0x5d
          .byte 0x20
          .byte 0x25
          .byte 0x73
          .byte 0x20
          .byte 0x6c
          .byte 0x65
          .byte 0x6e
          .byte 0x3d
          .byte 0x25
          .byte 0x64
          .byte 0x20
          .byte 0x65
          .byte 0x72
          .byte 0x72
          .byte 0x6f
          .byte 0x72
          .byte 0xa
          .byte 0x0
.L_ffffff80092527aa:
          .string "[eas_ctrl]kicker:%d error\n"
.L_ffffff80092527c5:
          .ascii "[eas_ctrl]"
.L_ffffff80092527cf:
          .ascii " "
.L_ffffff80092527d0:
          .string "kicker:%d error\n"
.L_ffffff80092527e1:
          .string "[M4U] init larb %d error\n"
.L_ffffff8009263a7f:
          .byte 0x1
          .byte 0x35
          .byte 0x5b
          .byte 0x63
          .byte 0x63
          .byte 0x63
          .byte 0x69
          .byte 0x25
          .byte 0x64
          .byte 0x2f
          .byte 0x66
          .byte 0x73
          .byte 0x6d
          .byte 0x5d
          .byte 0x64
          .byte 0x72
          .byte 0x6f
          .byte 0x70
          .byte 0x20
          .byte 0x69
          .byte 0x6e
          .byte 0x76
          .byte 0x61
          .byte 0x6c
          .byte 0x69
          .byte 0x64
          .byte 0x20
          .byte 0x75
          .byte 0x73
          .byte 0x65
          .byte 0x72
          .byte 0x3a
          .byte 0x25
          .byte 0x73
          .byte 0x20
          .byte 0x63
          .byte 0x61
          .byte 0x6c
          .byte 0x6c
          .byte 0x20
          .byte 0x4d
          .byte 0x44
          .byte 0x20
          .byte 0x73
          .byte 0x74
          .byte 0x61
          .byte 0x72
          .byte 0x74
          .byte 0x20
          .byte 0x69
          .byte 0x6f
          .byte 0x63
          .byte 0x74
          .byte 0x6c
          .byte 0xa
          .byte 0x0
.L_ffffff8009263ab7:
          .string "[%d]drop invalid user:%s call MD start ioctl\n"
.L_ffffff8009263ae5:
          .string "%s: get aee_siginfo ioctl\n"
.L_ffffff8009263b00:
          .string "%s: check suid dumpable ioctl\n"
.L_ffffff8009263b1f:
          .byte 0x1
          .byte 0x33
          .byte 0x25
          .byte 0x73
          .byte 0x3a
          .byte 0x66
          .byte 0x61
          .byte 0x69
          .byte 0x6c
          .byte 0x65
          .byte 0x64
          .byte 0x20
          .byte 0x74
          .byte 0x6f
          .byte 0x20
          .byte 0x67
          .byte 0x65
          .byte 0x74
          .byte 0x20
          .byte 0x70
          .byte 0x69
          .byte 0x6e
          .byte 0x63
          .byte 0x74
          .byte 0x72
          .byte 0x6c
          .byte 0xa
          .byte 0x0
.L_ffffff8009263b3b:
          .string "obtain a copy of previously claimed pinctrl\n"
.L_ffffff8009263b68:
          .string "Set drv curr(0~3): echo drvcurr v1 v2 v3 v4 v5 v6 v7 > /sys/power/clk_buf/clk_buf_ctrl\n"
.L_ffffff8009274e3b:
          .byte 0x1
          .byte 0x34
          .byte 0x25
          .byte 0x73
          .byte 0x3a
          .byte 0x20
          .byte 0x64
          .byte 0x65
          .byte 0x66
          .byte 0x69
          .byte 0x6e
          .byte 0x65
          .byte 0x73
          .byte 0x20
          .byte 0x65
          .byte 0x6e
          .byte 0x68
          .byte 0x61
          .byte 0x6e
          .byte 0x63
          .byte 0x65
          .byte 0x64
          .byte 0x20
          .byte 0x61
          .byte 0x72
          .byte 0x65
          .byte 0x61
          .byte 0x20
          .byte 0x77
          .byte 0x69
          .byte 0x74
          .byte 0x68
          .byte 0x6f
          .byte 0x75
          .byte 0x74
          .byte 0x20
          .byte 0x70
          .byte 0x61
          .byte 0x72
          .byte 0x74
          .byte 0x69
          .byte 0x74
          .byte 0x69
          .byte 0x6f
          .byte 0x6e
          .byte 0x20
          .byte 0x73
          .byte 0x65
          .byte 0x74
          .byte 0x74
          .byte 0x69
          .byte 0x6e
          .byte 0x67
          .byte 0x20
          .byte 0x63
          .byte 0x6f
          .byte 0x6d
          .byte 0x70
          .byte 0x6c
          .byte 0x65
          .byte 0x74
          .byte 0x65
          .byte 0xa
          .byte 0x0
.L_ffffff8009274e7b:
          .string "Emergency Sync complete\n"
.L_ffffff8009274e94:
          .string "urb complete\n"
.L_ffffff8009274ea2:
          .string "%s EP%d, deq=%p, enq=%p, complete\n"
.L_ffffff8009274ec5:
          .byte 0x1
          .byte 0x33
          .byte 0x25
          .byte 0x73
          .byte 0x3a
          .byte 0x63
          .byte 0x61
          .byte 0x6e
          .byte 0x20
          .byte 0x6e
          .byte 0x6f
          .byte 0x74
          .byte 0x20
          .byte 0x67
          .byte 0x65
          .byte 0x74
          .byte 0x20
          .byte 0x72
          .byte 0x65
          .byte 0x73
          .byte 0x65
          .byte 0x74
          .byte 0x20
          .byte 0x70
          .byte 0x69
          .byte 0x6e
          .byte 0x73
          .byte 0x74
          .byte 0x61
          .byte 0x74
          .byte 0x65
          .byte 0xa
          .byte 0x0
.L_ffffff8009274ee6:
          .byte 0x1
          .byte 0x33
          .byte 0x25
          .byte 0x73
          .byte 0x3a
          .byte 0x63
          .byte 0x61
          .byte 0x6e
          .byte 0x20
          .byte 0x6e
          .byte 0x6f
          .byte 0x74
          .byte 0x20
          .byte 0x67
          .byte 0x65
          .byte 0x74
          .byte 0x20
          .byte 0x69
          .byte 0x72
          .byte 0x71
          .byte 0x20
          .byte 0x70
          .byte 0x69
          .byte 0x6e
          .byte 0x73
          .byte 0x74
          .byte 0x61
          .byte 0x74
          .byte 0x65
          .byte 0xa
          .byte 0x0
.L_ffffff8009274f05:
          .string "out of memory in extcon_set_state\n"
.L_ffffff8009274f28:
          .string "dpidle help:   cat %s/dpidle_state\n"
.L_ffffff8009274f4c:
          .string "echo disable id > %s/dpidle_state\n"
.L_ffffff8009274f6f:
          .string "echo enable id > %s/dpidle_state\n"
.L_ffffff800927f99f:
          .byte 0x1
          .byte 0x33
          .byte 0x55
          .byte 0x6e
          .byte 0x61
          .byte 0x62
          .byte 0x6c
          .byte 0x65
          .byte 0x20
          .byte 0x74
          .byte 0x6f
          .byte 0x20
          .byte 0x72
          .byte 0x65
          .byte 0x67
          .byte 0x69
          .byte 0x73
          .byte 0x74
          .byte 0x65
          .byte 0x72
          .byte 0x20
          .byte 0x6d
          .byte 0x69
          .byte 0x6e
          .byte 0x6f
          .byte 0x72
          .byte 0x73
          .byte 0x20
          .byte 0x66
          .byte 0x6f
          .byte 0x72
          .byte 0x20
          .byte 0x75
          .byte 0x73
          .byte 0x62
          .byte 0x5f
          .byte 0x64
          .byte 0x65
          .byte 0x76
          .byte 0x69
          .byte 0x63
          .byte 0x65
          .byte 0xa
          .byte 0x0
.L_ffffff800927f9cb:
          .string "couldn't allocate usb_device\n"
.L_ffffff800927f9e9:
          .string "%s: Failed to query device\n"
.L_ffffff800927fa05:
          .string "Unable to register battery device\n"
.L_ffffff800927fa28:
          .string "ASoC: Invalid auxiliary device\n"
.L_ffffff800927fa48:
          .string "unable to register input device\n"
.L_ffffff800927fa69:
          .string "%s: Failed to set up input device\n"
.L_ffffff800927fa8c:
          .string "%s: failed to allocate input device\n"
.L_ffffff800927fab1:
          .byte 0x1
          .byte 0x36
          .byte 0x64
          .byte 0x65
          .byte 0x76
          .byte 0x69
          .byte 0x63
          .byte 0x65
          .byte 0x2d
          .byte 0x6d
          .byte 0x61
          .byte 0x70
          .byte 0x70
          .byte 0x65
          .byte 0x72
          .byte 0x3a
          .byte 0x20
          .byte 0x75
          .byte 0x65
          .byte 0x76
          .byte 0x65
          .byte 0x6e
          .byte 0x74
          .byte 0x3a
          .byte 0x20
          .byte 0x25
          .byte 0x73
          .byte 0x3a
          .byte 0x20
          .byte 0x73
          .byte 0x6b
          .byte 0x69
          .byte 0x70
          .byte 0x70
          .byte 0x69
          .byte 0x6e
          .byte 0x67
          .byte 0x20
          .byte 0x73
          .byte 0x65
          .byte 0x6e
          .byte 0x64
          .byte 0x69
          .byte 0x6e
          .byte 0x67
          .byte 0x20
          .byte 0x75
          .byte 0x65
          .byte 0x76
          .byte 0x65
          .byte 0x6e
          .byte 0x74
          .byte 0x20
          .byte 0x66
          .byte 0x6f
          .byte 0x72
          .byte 0x20
          .byte 0x6c
          .byte 0x6f
          .byte 0x73
          .byte 0x74
          .byte 0x20
          .byte 0x64
          .byte 0x65
          .byte 0x76
          .byte 0x69
          .byte 0x63
          .byte 0x65
          .byte 0xa
          .byte 0x0
.L_ffffff800927faf7:
          .string "Broadcast device\n"
.L_ffffff800927fb09:
          .byte 0x1
          .byte 0x33
          .byte 0x45
          .byte 0x58
          .byte 0x54
          .byte 0x34
          .byte 0x2d
          .byte 0x66
          .byte 0x73
          .byte 0x3a
          .byte 0x20
          .byte 0x25
          .byte 0x73
          .byte 0x3a
          .byte 0x25
          .byte 0x64
          .byte 0x3a
          .byte 0x20
          .byte 0x69
          .byte 0x6e
          .byte 0x6f
          .byte 0x64
          .byte 0x65
          .byte 0x20
          .byte 0x6f
          .byte 0x6e
          .byte 0x20
          .byte 0x6e
          .byte 0x6f
          .byte 0x6e
          .byte 0x65
          .byte 0x78
          .byte 0x69
          .byte 0x73
          .byte 0x74
          .byte 0x65
          .byte 0x6e
          .byte 0x74
          .byte 0x20
          .byte 0x64
          .byte 0x65
          .byte 0x76
          .byte 0x69
          .byte 0x63
          .byte 0x65
          .byte 0xa
          .byte 0x0
.L_ffffff8009287d46:
          .byte 0x1
          .byte 0x36
          .byte 0x5b
          .byte 0x50
          .byte 0x6f
          .byte 0x77
          .byte 0x65
          .byte 0x72
          .byte 0x2f
          .byte 0x63
          .byte 0x6c
          .byte 0x6b
          .byte 0x62
          .byte 0x75
          .byte 0x66
          .byte 0x5d
          .byte 0x20
          .byte 0x25
          .byte 0x73
          .byte 0x3a
          .byte 0x20
          .byte 0x69
          .byte 0x64
          .byte 0x3d
          .byte 0x25
          .byte 0x64
          .byte 0x20
          .byte 0x69
          .byte 0x73
          .byte 0x6e
          .byte 0x27
          .byte 0x74
          .byte 0x20
          .byte 0x73
          .byte 0x75
          .byte 0x70
          .byte 0x70
          .byte 0x6f
          .byte 0x72
          .byte 0x74
          .byte 0x65
          .byte 0x64
          .byte 0xa
          .byte 0x0
.L_ffffff8009287d72:
          .byte 0x1
          .byte 0x36
          .byte 0x25
          .byte 0x73
          .byte 0x3a
          .byte 0x20
          .byte 0x6d
          .byte 0x75
          .byte 0x6c
          .byte 0x74
          .byte 0x69
          .byte 0x70
          .byte 0x6c
          .byte 0x65
          .byte 0x20
          .byte 0x72
          .byte 0x61
          .byte 0x6e
          .byte 0x67
          .byte 0x65
          .byte 0x73
          .byte 0x20
          .byte 0x6e
          .byte 0x6f
          .byte 0x20
          .byte 0x6c
          .byte 0x6f
          .byte 0x6e
          .byte 0x67
          .byte 0x65
          .byte 0x72
          .byte 0x20
          .byte 0x73
          .byte 0x75
          .byte 0x70
          .byte 0x70
          .byte 0x6f
          .byte 0x72
          .byte 0x74
          .byte 0x65
          .byte 0x64
          .byte 0xa
          .byte 0x0
.L_ffffff8009287d9d:
          .string "can_queue = 0 no longer supported\n"
.L_ffffff8009287dc0:
          .ascii "Port indicators are "
.L_ffffff8009287dd4:
          .string "supported\n"
.L_ffffff8009287ddf:
          .string "SMBUS Byte Data not Supported\n"
.L_ffffff8009287dfe:
          .string "CaDeFa Supported\n"
.L_ffffff8009287e10:
          .string "%s: UIC Lane error reported\n"
.L_ffffff8009287e2d:
          .string "There were multiple GPU faults - some have not been reported\n"
.L_ffffff8009287e6b:
          .string "Unexpected response from lun %llu while scanning, scan aborted\n"
.L_ffffff80092b5d17:
          .string "irq poll in progress on cpu %d for irq %d\n"
.L_ffffff80092b5d42:
          .byte 0x1
          .byte 0x33
          .byte 0x67
          .byte 0x65
          .byte 0x6e
          .byte 0x69
          .byte 0x72
          .byte 0x71
          .byte 0x3a
          .byte 0x20
          .byte 0x54
          .byte 0x68
          .byte 0x72
          .byte 0x65
          .byte 0x61
          .byte 0x64
          .byte 0x65
          .byte 0x64
          .byte 0x20
          .byte 0x69
          .byte 0x72
          .byte 0x71
          .byte 0x20
          .byte 0x72
          .byte 0x65
          .byte 0x71
          .byte 0x75
          .byte 0x65
          .byte 0x73
          .byte 0x74
          .byte 0x65
          .byte 0x64
          .byte 0x20
          .byte 0x77
          .byte 0x69
          .byte 0x74
          .byte 0x68
          .byte 0x20
          .byte 0x68
          .byte 0x61
          .byte 0x6e
          .byte 0x64
          .byte 0x6c
          .byte 0x65
          .byte 0x72
          .byte 0x3d
          .byte 0x4e
          .byte 0x55
          .byte 0x4c
          .byte 0x4c
          .byte 0x20
          .byte 0x61
          .byte 0x6e
          .byte 0x64
          .byte 0x20
          .byte 0x21
          .byte 0x4f
          .byte 0x4e
          .byte 0x45
          .byte 0x53
          .byte 0x48
          .byte 0x4f
          .byte 0x54
          .byte 0x20
          .byte 0x66
          .byte 0x6f
          .byte 0x72
          .byte 0x20
          .byte 0x69
          .byte 0x72
          .byte 0x71
          .byte 0x20
          .byte 0x25
          .byte 0x64
          .byte 0xa
          .byte 0x0
.L_ffffff80092b5d8e:
          .string "Primary handler called for nested irq %d\n"
.L_ffffff80092b5db8:
          .ascii "%s: keypad, "
.L_ffffff80092b5dc4:
          .string "irq %d\n"
.L_ffffff80092b5dcc:
          .string "Unable to register with devfreq %d\n"
.L_ffffff80092b5df0:
          .byte 0x1
          .byte 0x33
          .byte 0x5b
          .byte 0x73
          .byte 0x63
          .byte 0x70
          .byte 0x5f
          .byte 0x64
          .byte 0x76
          .byte 0x66
          .byte 0x73
          .byte 0x5d
          .byte 0x3a
          .byte 0x20
          .byte 0x45
          .byte 0x52
          .byte 0x52
          .byte 0x4f
          .byte 0x52
          .byte 0x3a
          .byte 0x20
          .byte 0x25
          .byte 0x73
          .byte 0x3a
          .byte 0x20
          .byte 0x6e
          .byte 0x6f
          .byte 0x74
          .byte 0x20
          .byte 0x73
          .byte 0x75
          .byte 0x70
          .byte 0x70
          .byte 0x6f
          .byte 0x72
          .byte 0x74
          .byte 0x20
          .byte 0x6f
          .byte 0x70
          .byte 0x70
          .byte 0x20
          .byte 0x66
          .byte 0x72
          .byte 0x65
          .byte 0x71
          .byte 0x20
          .byte 0x25
          .byte 0x64
          .byte 0xa
          .byte 0x0
.L_ffffff80092b5e22:
          .byte 0x1
          .byte 0x36
          .byte 0x7a
          .byte 0x73
          .byte 0x6d
          .byte 0x61
          .byte 0x6c
          .byte 0x6c
          .byte 0x6f
          .byte 0x63
          .byte 0x3a
          .byte 0x20
          .byte 0x46
          .byte 0x72
          .byte 0x65
          .byte 0x65
          .byte 0x69
          .byte 0x6e
          .byte 0x67
          .byte 0x20
          .byte 0x6e
          .byte 0x6f
          .byte 0x6e
          .byte 0x2d
          .byte 0x65
          .byte 0x6d
          .byte 0x70
          .byte 0x74
          .byte 0x79
          .byte 0x20
          .byte 0x63
          .byte 0x6c
          .byte 0x61
          .byte 0x73
          .byte 0x73
          .byte 0x20
          .byte 0x77
          .byte 0x69
          .byte 0x74
          .byte 0x68
          .byte 0x20
          .byte 0x73
          .byte 0x69
          .byte 0x7a
          .byte 0x65
          .byte 0x20
          .byte 0x25
          .byte 0x64
          .byte 0x62
          .byte 0x2c
          .byte 0x20
          .byte 0x66
          .byte 0x75
          .byte 0x6c
          .byte 0x6c
          .byte 0x6e
          .byte 0x65
          .byte 0x73
          .byte 0x73
          .byte 0x20
          .byte 0x67
          .byte 0x72
          .byte 0x6f
          .byte 0x75
          .byte 0x70
          .byte 0x20
          .byte 0x25
          .byte 0x64
          .byte 0xa
          .byte 0x0
.L_ffffff80092c13c2:
          .string "[ccci%d/mcd]enable md sys clk done,ret = %d\n"
.L_ffffff80092c13ef:
          .string "[%d]enable md sys clk done,ret = %d\n"
.L_ffffff80092c1414:
          .string "[error] %s:  %s:sysfs_create_group failed,ret = %d\n"
.L_ffffff80092c1448:
          .string "%s: failed aw9523 irq=%d request ret = %d\n"
.L_ffffff80092c1473:
          .byte 0x1
          .byte 0x36
          .byte 0x25
          .byte 0x73
          .byte 0x3a
          .byte 0x25
          .byte 0x64
          .byte 0x3a
          .byte 0x20
          .byte 0x25
          .byte 0x73
          .byte 0x20
          .byte 0x72
          .byte 0x65
          .byte 0x74
          .byte 0x20
          .byte 0x3d
          .byte 0x20
          .byte 0x25
          .byte 0x64
          .byte 0xa
          .byte 0x0
.L_ffffff80092c1489:
          .string "[error] %s: get voltage error ret = %d\n"
.L_ffffff80092c14b1:
          .byte 0x1
          .byte 0x35
          .byte 0x5b
          .byte 0x63
          .byte 0x63
          .byte 0x63
          .byte 0x69
          .byte 0x25
          .byte 0x64
          .byte 0x2f
          .byte 0x63
          .byte 0x68
          .byte 0x72
          .byte 0x5d
          .byte 0x70
          .byte 0x6f
          .byte 0x72
          .byte 0x74
          .byte 0x20
          .byte 0x25
          .byte 0x73
          .byte 0x20
          .byte 0x73
          .byte 0x65
          .byte 0x6e
          .byte 0x64
          .byte 0x20
          .byte 0x73
          .byte 0x6b
          .byte 0x62
          .byte 0x20
          .byte 0x66
          .byte 0x61
          .byte 0x69
          .byte 0x6c
          .byte 0x20
          .byte 0x72
          .byte 0x65
          .byte 0x74
          .byte 0x20
          .byte 0x3d
          .byte 0x20
          .byte 0x25
          .byte 0x64
          .byte 0xa
          .byte 0x0
.L_ffffff80092c14df:
          .string "[%d]port %s send skb fail ret = %d\n"
.L_ffffff80092ca754:
          .string "%s, netdev:%s(%d), station mac: %pM, idx: %d\n"
.L_ffffff80092ca782:
          .byte 0x1
          .byte 0x33
          .byte 0x25
          .byte 0x73
          .byte 0x3a
          .byte 0x25
          .byte 0x64
          .byte 0x3a
          .byte 0x20
          .byte 0x25
          .byte 0x73
          .byte 0x20
          .byte 0x6e
          .byte 0x6f
          .byte 0x74
          .byte 0x20
          .byte 0x73
          .byte 0x74
          .byte 0x6f
          .byte 0x72
          .byte 0x65
          .byte 0x28
          .byte 0x25
          .byte 0x64
          .byte 0x29
          .byte 0x20
          .byte 0x6f
          .byte 0x74
          .byte 0x70
          .byte 0x20
          .byte 0x6f
          .byte 0x72
          .byte 0x20
          .byte 0x63
          .byte 0x6f
          .byte 0x75
          .byte 0x6e
          .byte 0x74
          .byte 0x20
          .byte 0x65
          .byte 0x78
          .byte 0x63
          .byte 0x65
          .byte 0x65
          .byte 0x64
          .byte 0x73
          .byte 0x20
          .byte 0x6d
          .byte 0x61
          .byte 0x78
          .byte 0x3a
          .byte 0x20
          .byte 0x25
          .byte 0x64
          .byte 0xa
          .byte 0x0
.L_ffffff80092ca7ba:
          .byte 0x1
          .byte 0x36
          .byte 0x25
          .byte 0x73
          .byte 0x3a
          .byte 0x25
          .byte 0x64
          .byte 0x3a
          .byte 0x20
          .byte 0x25
          .byte 0x73
          .byte 0x20
          .byte 0x73
          .byte 0x70
          .byte 0x6b
          .byte 0x72
          .byte 0x3a
          .byte 0x20
          .byte 0x25
          .byte 0x64
          .byte 0x2c
          .byte 0x20
          .byte 0x6d
          .byte 0x69
          .byte 0x6e
          .byte 0x3a
          .byte 0x20
          .byte 0x25
          .byte 0x64
          .byte 0x2c
          .byte 0x20
          .byte 0x6d
          .byte 0x61
          .byte 0x78
          .byte 0x3a
          .byte 0x20
          .byte 0x25
          .byte 0x64
          .byte 0xa
          .byte 0x0
.L_ffffff80092ca7e2:
          .string "i2c write fail: can't write %02x to %02x: %d\n"
.L_ffffff80092ca810:
          .string "i2c read fail: can't read from %02x: %d\n"
.L_ffffff80092ca839:
          .string "Failed to write %x = %x: %d\n"
.L_ffffff80092ca856:
          .byte 0x1
          .byte 0x36
          .byte 0x5b
          .byte 0x50
          .byte 0x42
          .byte 0x4d
          .byte 0x5d
          .byte 0x20
          .byte 0x4d
          .byte 0x44
          .byte 0x31
          .byte 0x20
          .byte 0x73
          .byte 0x63
          .byte 0x65
          .byte 0x6e
          .byte 0x61
          .byte 0x72
          .byte 0x69
          .byte 0x6f
          .byte 0x3a
          .byte 0x20
          .byte 0x30
          .byte 0x78
          .byte 0x25
          .byte 0x78
          .byte 0x2c
          .byte 0x20
          .byte 0x72
          .byte 0x65
          .byte 0x67
          .byte 0x3a
          .byte 0x20
          .byte 0x30
          .byte 0x78
          .byte 0x25
          .byte 0x78
          .byte 0x2c
          .byte 0x20
          .byte 0x70
          .byte 0x77
          .byte 0x3a
          .byte 0x20
          .byte 0x25
          .byte 0x64
          .byte 0xa
          .byte 0x0
.L_ffffff80092ca885:
          .string "cq_tuning_now: %d\n"
.L_ffffff80092ca898:
          .byte 0x1
          .byte 0x36
          .byte 0x25
          .byte 0x73
          .byte 0x3a
          .byte 0x25
          .byte 0x64
          .byte 0x3a
          .byte 0x20
          .byte 0x25
          .byte 0x73
          .byte 0x20
          .byte 0x72
          .byte 0x65
          .byte 0x32
          .byte 0x35
          .byte 0x20
          .byte 0x6f
          .byte 0x6c
          .byte 0x64
          .byte 0x3a
          .byte 0x20
          .byte 0x25
          .byte 0x64
          .byte 0x2c
          .byte 0x20
          .byte 0x6e
          .byte 0x65
          .byte 0x77
          .byte 0x3a
          .byte 0x20
          .byte 0x25
          .byte 0x64
          .byte 0xa
          .byte 0x0
.L_ffffff80092d33c1:
          .byte 0x1
          .byte 0x33
          .byte 0x69
          .byte 0x6e
          .byte 0x63
          .byte 0x66
          .byte 0x73
          .byte 0x3a
          .byte 0x20
          .byte 0x4f
          .byte 0x70
          .byte 0x74
          .byte 0x69
          .byte 0x6f
          .byte 0x6e
          .byte 0x73
          .byte 0x20
          .byte 0x70
          .byte 0x61
          .byte 0x72
          .byte 0x73
          .byte 0x69
          .byte 0x6e
          .byte 0x67
          .byte 0x20
          .byte 0x65
          .byte 0x72
          .byte 0x72
          .byte 0x6f
          .byte 0x72
          .byte 0x2e
          .byte 0x20
          .byte 0x25
          .byte 0x64
          .byte 0xa
          .byte 0x0
.L_ffffff80092d33e5:
          .byte 0x1
          .byte 0x33
          .byte 0x69
          .byte 0x6e
          .byte 0x63
          .byte 0x66
          .byte 0x73
          .byte 0x3a
          .byte 0x20
          .byte 0x45
          .byte 0x72
          .byte 0x72
          .byte 0x6f
          .byte 0x72
          .byte 0x20
          .byte 0x61
          .byte 0x6c
          .byte 0x6c
          .byte 0x6f
          .byte 0x63
          .byte 0x61
          .byte 0x74
          .byte 0x69
          .byte 0x6e
          .byte 0x67
          .byte 0x20
          .byte 0x6d
          .byte 0x6f
          .byte 0x75
          .byte 0x6e
          .byte 0x74
          .byte 0x20
          .byte 0x69
          .byte 0x6e
          .byte 0x66
          .byte 0x6f
          .byte 0x2e
          .byte 0x20
          .byte 0x25
          .byte 0x64
          .byte 0xa
          .byte 0x0
.L_ffffff80092d340f:
          .byte 0x1
          .byte 0x33
          .byte 0x5b
          .byte 0x53
          .byte 0x43
          .byte 0x50
          .byte 0x5d
          .byte 0x20
          .byte 0x61
          .byte 0x6c
          .byte 0x72
          .byte 0x65
          .byte 0x61
          .byte 0x64
          .byte 0x79
          .byte 0x20
          .byte 0x68
          .byte 0x6f
          .byte 0x6c
          .byte 0x64
          .byte 0x20
          .byte 0x73
          .byte 0x63
          .byte 0x70
          .byte 0x20
          .byte 0x73
          .byte 0x65
          .byte 0x6d
          .byte 0x61
          .byte 0x2e
          .byte 0x20
          .byte 0x25
          .byte 0x64
          .byte 0xa
          .byte 0x0
.L_ffffff80092d3432:
          .byte 0x1
          .byte 0x36
.L_ffffff80092d3434:
          .string "[ccci%d/rpc]%s-- %d\n"
.L_ffffff80092d3449:
          .string "%s: cnt = %d key_report: p0-row=%d, p1-col=%d, key_code=%d, key_val=%d keymap%d --- %d\n"
.L_ffffff80092d34a1:
          .string "%u:%u -- %d\n"
.L_ffffff80092d34ae:
          .string "global -- %d\n"
.L_ffffff80092d34bc:
          .byte 0x1
          .byte 0x36
          .byte 0x44
          .byte 0x57
          .byte 0x39
          .byte 0x37
          .byte 0x31
          .byte 0x38
          .byte 0x54
          .byte 0x41
          .byte 0x46
          .byte 0x5f
          .byte 0x44
          .byte 0x52
          .byte 0x56
          .byte 0x20
          .byte 0x5b
          .byte 0x25
          .byte 0x73
          .byte 0x5d
          .byte 0x20
          .byte 0x61
          .byte 0x70
          .byte 0x70
          .byte 0x6c
          .byte 0x79
          .byte 0x20
          .byte 0x2d
          .byte 0x20
          .byte 0x25
          .byte 0x64
          .byte 0xa
          .byte 0x0
.L_ffffff80092d34dd:
          .byte 0x1
          .byte 0x36
          .byte 0x44
          .byte 0x57
          .byte 0x39
          .byte 0x37
          .byte 0x31
          .byte 0x38
          .byte 0x53
          .byte 0x41
          .byte 0x46
          .byte 0x5f
          .byte 0x44
          .byte 0x52
          .byte 0x56
          .byte 0x20
          .byte 0x5b
          .byte 0x25
          .byte 0x73
          .byte 0x5d
          .byte 0x20
          .byte 0x61
          .byte 0x70
          .byte 0x70
          .byte 0x6c
          .byte 0x79
          .byte 0x20
          .byte 0x2d
          .byte 0x20
          .byte 0x25
          .byte 0x64
          .byte 0xa
          .byte 0x0
.L_ffffff80092d34fe:
          .byte 0x1
          .byte 0x37
          .byte 0x25
          .byte 0x73
          .byte 0x3a
          .byte 0x20
          .byte 0x4d
          .byte 0x61
          .byte 0x78
          .byte 0x69
          .byte 0x6d
          .byte 0x75
          .byte 0x6d
          .byte 0x20
          .byte 0x45
          .byte 0x66
          .byte 0x66
          .byte 0x65
          .byte 0x63
          .byte 0x74
          .byte 0x73
          .byte 0x20
          .byte 0x2d
          .byte 0x20
          .byte 0x25
          .byte 0x64
          .byte 0xa
          .byte 0x0
.L_ffffff80092d351a:
          .string "try to request_firmware() %s - %d\n"
.L_ffffff80092d52e4:
          .byte 0x1
          .byte 0x34
          .byte 0x73
          .byte 0x69
          .byte 0x74
          .byte 0x3a
          .byte 0x20
          .byte 0x53
          .byte 0x72
          .byte 0x63
          .byte 0x20
          .byte 0x73
          .byte 0x70
          .byte 0x6f
          .byte 0x6f
          .byte 0x66
          .byte 0x65
          .byte 0x64
          .byte 0x20
          .byte 0x25
          .byte 0x70
          .byte 0x49
          .byte 0x34
          .byte 0x2f
          .byte 0x25
          .byte 0x70
          .byte 0x49
          .byte 0x36
          .byte 0x63
          .byte 0x20
          .byte 0x2d
          .byte 0x3e
          .byte 0x20
          .byte 0x25
          .byte 0x70
          .byte 0x49
          .byte 0x34
          .byte 0x2f
          .byte 0x25
          .byte 0x70
          .byte 0x49
          .byte 0x36
          .byte 0x63
          .byte 0xa
          .byte 0x0
.L_ffffff80092d5311:
          .string "table %3u oif %d iif %d src %pI6c dst %pI6c tos %d scope %d flags %x ==> dev %s gw %pI6c\n"
.L_ffffff80092d536b:
          .string "fail to add aw9523 device into i2c\n"
.L_ffffff80092d538f:
          .string "%-9s %4u %6d  %6ld   %-3s %6u   %-3s  %-10s %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c\n"
.L_ffffff80092d5408:
          .string "load thresh=%d%c\n"
.L_ffffff80092db2af:
          .byte 0x1
          .byte 0x35
          .byte 0x5b
          .byte 0x50
          .byte 0x72
          .byte 0x6f
          .byte 0x66
          .byte 0x69
          .byte 0x6c
          .byte 0x65
          .byte 0x5f
          .byte 0x54
          .byte 0x61
          .byte 0x62
          .byte 0x6c
          .byte 0x65
          .byte 0x5d
          .byte 0x6c
          .byte 0x6f
          .byte 0x77
          .byte 0x54
          .byte 0x20
          .byte 0x25
          .byte 0x64
          .byte 0x20
          .byte 0x25
          .byte 0x64
          .byte 0x20
          .byte 0x25
          .byte 0x64
          .byte 0x20
          .byte 0x4c
          .byte 0x6f
          .byte 0x77
          .byte 0x53
          .byte 0x68
          .byte 0x75
          .byte 0x74
          .byte 0x5a
          .byte 0x43
          .byte 0x56
          .byte 0x20
          .byte 0x25
          .byte 0x64
          .byte 0x20
          .byte 0x48
          .byte 0x69
          .byte 0x67
          .byte 0x68
          .byte 0x53
          .byte 0x68
          .byte 0x75
          .byte 0x74
          .byte 0x5a
          .byte 0x43
          .byte 0x56
          .byte 0x20
          .byte 0x25
          .byte 0x64
          .byte 0x20
          .byte 0x73
          .byte 0x68
          .byte 0x75
          .byte 0x74
          .byte 0x64
          .byte 0x6f
          .byte 0x77
          .byte 0x6e
          .byte 0x5f
          .byte 0x68
          .byte 0x6c
          .byte 0x5f
          .byte 0x7a
          .byte 0x63
          .byte 0x76
          .byte 0x20
          .byte 0x5b
          .byte 0x25
          .byte 0x64
          .byte 0x5d
          .byte 0xa
          .byte 0x0
.L_ffffff80092db301:
          .string "%d,%d %s %llu + %u [%d]\n"
.L_ffffff80092db31a:
          .string "%d,%d %s (%s) %llu + %u [%d]\n"
.L_ffffff80092db338:
          .byte 0x1
          .byte 0x34
          .byte 0x5b
          .byte 0x50
          .byte 0x42
          .byte 0x4d
          .byte 0x5d
          .byte 0x20
          .byte 0x5b
          .byte 0x25
          .byte 0x73
          .byte 0x5d
          .byte 0x20
          .byte 0x45
          .byte 0x52
          .byte 0x52
          .byte 0x4f
          .byte 0x52
          .byte 0x2c
          .byte 0x20
          .byte 0x75
          .byte 0x6e
          .byte 0x6b
          .byte 0x6e
          .byte 0x6f
          .byte 0x77
          .byte 0x6e
          .byte 0x20
          .byte 0x6b
          .byte 0x69
          .byte 0x63
          .byte 0x6b
          .byte 0x65
          .byte 0x72
          .byte 0x20
          .byte 0x5b
          .byte 0x25
          .byte 0x64
          .byte 0x5d
          .byte 0xa
          .byte 0x0
.L_ffffff80092db361:
          .string "%s: unable to request gpio [%d]\n"
.L_ffffff80092db382:
          .string "%s: unable to set direction for gpio [%d]\n"
.L_ffffff80092db3ad:
          .byte 0x1
          .byte 0x35
          .byte 0x5b
          .byte 0x50
          .byte 0x72
          .byte 0x6f
          .byte 0x66
          .byte 0x69
          .byte 0x6c
          .byte 0x65
          .byte 0x5f
          .byte 0x54
          .byte 0x61
          .byte 0x62
          .byte 0x6c
          .byte 0x65
          .byte 0x5d
          .byte 0x6c
          .byte 0x6f
          .byte 0x77
          .byte 0x54
          .byte 0x20
          .byte 0x25
          .byte 0x64
          .byte 0x20
          .byte 0x25
          .byte 0x64
          .byte 0x20
          .byte 0x25
          .byte 0x64
          .byte 0x20
          .byte 0x6c
          .byte 0x6f
          .byte 0x77
          .byte 0x51
          .byte 0x68
          .byte 0x20
          .byte 0x25
          .byte 0x64
          .byte 0x20
          .byte 0x25
          .byte 0x64
          .byte 0x20
          .byte 0x71
          .byte 0x6d
          .byte 0x61
          .byte 0x78
          .byte 0x5f
          .byte 0x74
          .byte 0x5f
          .byte 0x4e
          .byte 0x6d
          .byte 0x61
          .byte 0x5f
          .byte 0x68
          .byte 0x20
          .byte 0x5b
          .byte 0x25
          .byte 0x64
          .byte 0x5d
          .byte 0xa
          .byte 0x0
.L_ffffff80092db3eb:
          .byte 0x1
          .byte 0x35
          .byte 0x5b
          .byte 0x50
          .byte 0x72
          .byte 0x6f
          .byte 0x66
          .byte 0x69
          .byte 0x6c
          .byte 0x65
          .byte 0x5f
          .byte 0x54
          .byte 0x61
          .byte 0x62
          .byte 0x6c
          .byte 0x65
          .byte 0x5d
          .byte 0x6c
          .byte 0x6f
          .byte 0x77
          .byte 0x54
          .byte 0x20
          .byte 0x25
          .byte 0x64
          .byte 0x20
          .byte 0x25
          .byte 0x64
          .byte 0x20
          .byte 0x25
          .byte 0x64
          .byte 0x20
          .byte 0x6c
          .byte 0x6f
          .byte 0x77
          .byte 0x51
          .byte 0x20
          .byte 0x25
          .byte 0x64
          .byte 0x20
          .byte 0x25
          .byte 0x64
          .byte 0x20
          .byte 0x71
          .byte 0x6d
          .byte 0x61
          .byte 0x78
          .byte 0x5f
          .byte 0x74
          .byte 0x5f
          .byte 0x30
          .byte 0x6d
          .byte 0x61
          .byte 0x5f
          .byte 0x68
          .byte 0x20
          .byte 0x5b
          .byte 0x25
          .byte 0x64
          .byte 0x5d
          .byte 0xa
          .byte 0x0
.L_ffffff80092db428:
          .byte 0x1
          .byte 0x35
          .byte 0x5b
          .byte 0x50
          .byte 0x72
          .byte 0x6f
          .byte 0x66
          .byte 0x69
          .byte 0x6c
          .byte 0x65
          .byte 0x5f
          .byte 0x54
          .byte 0x61
          .byte 0x62
          .byte 0x6c
          .byte 0x65
          .byte 0x5d
          .byte 0x70
          .byte 0x73
          .byte 0x65
          .byte 0x75
          .byte 0x64
          .byte 0x6f
          .byte 0x31
          .byte 0x5f
          .byte 0x65
          .byte 0x6e
          .byte 0x3a
          .byte 0x5b
          .byte 0x25
          .byte 0x64
          .byte 0x5d
          .byte 0x20
          .byte 0x6c
          .byte 0x6f
          .byte 0x77
          .byte 0x54
          .byte 0x20
          .byte 0x25
          .byte 0x64
          .byte 0x20
          .byte 0x25
          .byte 0x64
          .byte 0x20
          .byte 0x25
          .byte 0x64
          .byte 0x20
          .byte 0x6c
          .byte 0x6f
          .byte 0x77
          .byte 0x50
          .byte 0x73
          .byte 0x31
          .byte 0x20
          .byte 0x25
          .byte 0x64
          .byte 0x20
          .byte 0x68
          .byte 0x69
          .byte 0x67
          .byte 0x68
          .byte 0x50
          .byte 0x73
          .byte 0x31
          .byte 0x20
          .byte 0x25
          .byte 0x64
          .byte 0x20
          .byte 0x62
          .byte 0x61
          .byte 0x74
          .byte 0x74
          .byte 0x65
          .byte 0x72
          .byte 0x79
          .byte 0x70
          .byte 0x73
          .byte 0x65
          .byte 0x75
          .byte 0x64
          .byte 0x6f
          .byte 0x31
          .byte 0x5f
          .byte 0x68
          .byte 0x20
          .byte 0x5b
          .byte 0x25
          .byte 0x64
          .byte 0x5d
          .byte 0xa
          .byte 0x0
.L_ffffff8009328fb5:
          .string "[%d]set user_id fail: copy_from_user fail!\n"
.L_ffffff8009328fe1:
          .string "<<GTP-ERR>>[%s:%d] copy from user fail!\n"
.L_ffffff800932900a:
          .string "GED:register fb_notifier fail!\n"
.L_ffffff800932902a:
          .byte 0x1
          .byte 0x36
          .byte 0x6d
          .byte 0x74
          .byte 0x6b
          .byte 0x2d
          .byte 0x74
          .byte 0x70
          .byte 0x64
          .byte 0x3a
          .byte 0x5b
          .byte 0x25
          .byte 0x73
          .byte 0x3a
          .byte 0x25
          .byte 0x64
          .byte 0x5d
          .byte 0x20
          .byte 0x72
          .byte 0x65
          .byte 0x67
          .byte 0x69
          .byte 0x73
          .byte 0x74
          .byte 0x65
          .byte 0x72
          .byte 0x20
          .byte 0x66
          .byte 0x62
          .byte 0x5f
          .byte 0x6e
          .byte 0x6f
          .byte 0x74
          .byte 0x69
          .byte 0x66
          .byte 0x69
          .byte 0x65
          .byte 0x72
          .byte 0x20
          .byte 0x66
          .byte 0x61
          .byte 0x69
          .byte 0x6c
          .byte 0x21
          .byte 0xa
          .byte 0x0
.L_ffffff8009329058:
          .ascii "mtk-pad: "
.L_ffffff8009329061:
          .string "register fb_notifier fail!\n"
.L_ffffff800932907d:
          .string "<<GTP-ERR>>[%s:%d] recall check ss51 isp fail!\n"
.L_ffffff80093290ad:
          .string "<<GTP-ERR>>[%s:%d] load ss51 isp fail!\n"
.L_ffffff80093290d5:
          .byte 0x1
          .byte 0x36
          .byte 0x69
          .byte 0x32
          .byte 0x63
          .byte 0x20
          .byte 0x64
          .byte 0x65
          .byte 0x62
          .byte 0x75
          .byte 0x67
          .byte 0x20
          .byte 0x73
          .byte 0x79
          .byte 0x73
          .byte 0x74
          .byte 0x65
          .byte 0x6d
          .byte 0x3a
          .byte 0x20
          .byte 0x67
          .byte 0x65
          .byte 0x74
          .byte 0x20
          .byte 0x61
          .byte 0x64
          .byte 0x61
          .byte 0x70
          .byte 0x20
          .byte 0x66
          .byte 0x61
          .byte 0x69
          .byte 0x6c
          .byte 0x21
          .byte 0xa
          .byte 0x0
.L_ffffff80093290f9:
          .byte 0x1
          .byte 0x33
          .byte 0x5b
          .byte 0x44
          .byte 0x49
          .byte 0x53
          .byte 0x50
          .byte 0x5d
          .byte 0x5b
          .byte 0x25
          .byte 0x73
          .byte 0x20
          .byte 0x23
          .byte 0x25
          .byte 0x64
          .byte 0x5d
          .byte 0x45
          .byte 0x52
          .byte 0x52
          .byte 0x4f
          .byte 0x52
          .byte 0x3a
.L_ffffff800932cccf:
          .string "<<GTP-ERR>>[%s:%d] Update config failed!\n"
.L_ffffff800932ccf9:
          .string "<<GTP-ERR>>[%s:%d] Send config failed!\n"
.L_ffffff800932cd21:
          .byte 0x1
          .byte 0x33
          .byte 0x5b
          .byte 0x54
          .byte 0x4d
          .byte 0x45
          .byte 0x4d
          .byte 0x5d
          .byte 0x74
          .byte 0x72
          .byte 0x75
          .byte 0x73
          .byte 0x74
          .byte 0x65
          .byte 0x64
          .byte 0x20
          .byte 0x6d
          .byte 0x65
          .byte 0x6d
          .byte 0x20
          .byte 0x70
          .byte 0x6f
          .byte 0x77
          .byte 0x65
          .byte 0x72
          .byte 0x6f
          .byte 0x66
          .byte 0x66
          .byte 0x20
          .byte 0x66
          .byte 0x61
          .byte 0x69
          .byte 0x6c
          .byte 0x65
          .byte 0x64
          .byte 0x21
          .byte 0xa
          .byte 0x0
.L_ffffff800932cd47:
          .string "<<GTP-ERR>>[%s:%d] Create workqueue failed!\n"
.L_ffffff800932cd74:
          .byte 0x1
          .byte 0x33
          .byte 0x25
          .byte 0x73
          .byte 0x3a
          .byte 0x73
          .byte 0x65
          .byte 0x74
          .byte 0x20
          .byte 0x72
          .byte 0x65
          .byte 0x73
          .byte 0x65
          .byte 0x74
          .byte 0x20
          .byte 0x70
          .byte 0x69
          .byte 0x6e
          .byte 0x20
          .byte 0x73
          .byte 0x74
          .byte 0x61
          .byte 0x74
          .byte 0x65
          .byte 0x20
          .byte 0x66
          .byte 0x61
          .byte 0x69
          .byte 0x6c
          .byte 0x65
          .byte 0x64
          .byte 0x21
          .byte 0xa
          .byte 0x0
.L_ffffff800932cd96:
          .byte 0x1
          .byte 0x33
          .byte 0x25
          .byte 0x73
          .byte 0x3a
          .byte 0x73
          .byte 0x65
          .byte 0x74
          .byte 0x20
          .byte 0x69
          .byte 0x72
          .byte 0x71
          .byte 0x20
          .byte 0x70
          .byte 0x69
          .byte 0x6e
          .byte 0x20
          .byte 0x73
          .byte 0x74
          .byte 0x61
          .byte 0x74
          .byte 0x65
          .byte 0x20
          .byte 0x66
          .byte 0x61
          .byte 0x69
          .byte 0x6c
          .byte 0x65
          .byte 0x64
          .byte 0x21
          .byte 0xa
          .byte 0x0
.L_ffffff800932cdb6:
          .byte 0x1
          .byte 0x35
          .byte 0x5b
          .byte 0x25
          .byte 0x73
          .byte 0x5d
          .byte 0x20
          .byte 0x25
          .byte 0x73
          .byte 0x2c
          .byte 0x20
          .byte 0x69
          .byte 0x6e
          .byte 0x69
          .byte 0x74
          .byte 0x20
          .byte 0x63
          .byte 0x6c
          .byte 0x61
          .byte 0x73
          .byte 0x73
          .byte 0x5f
          .byte 0x63
          .byte 0x72
          .byte 0x65
          .byte 0x61
          .byte 0x74
          .byte 0x65
          .byte 0x20
          .byte 0x66
          .byte 0x61
          .byte 0x69
          .byte 0x6c
          .byte 0x65
          .byte 0x64
          .byte 0x21
          .byte 0xa
          .byte 0x0
.L_ffffff800932cddc:
          .byte 0x1
          .byte 0x35
          .byte 0x5b
          .byte 0x25
          .byte 0x73
          .byte 0x5d
          .byte 0x20
          .byte 0x25
          .byte 0x73
          .byte 0x2c
          .byte 0x20
          .byte 0x69
          .byte 0x6e
          .byte 0x69
          .byte 0x74
          .byte 0x20
          .byte 0x64
          .byte 0x65
          .byte 0x76
          .byte 0x69
          .byte 0x63
          .byte 0x65
          .byte 0x5f
          .byte 0x63
          .byte 0x72
          .byte 0x65
          .byte 0x61
          .byte 0x74
          .byte 0x65
          .byte 0x20
          .byte 0x66
          .byte 0x61
          .byte 0x69
          .byte 0x6c
          .byte 0x65
          .byte 0x64
          .byte 0x21
          .byte 0xa
          .byte 0x0
.L_ffffff800932ce03:
          .string "gz_log proc_create failed!\n"
.L_ffffff800932ce1f:
          .byte 0x1
          .byte 0x35
          .byte 0x5b
          .byte 0x4d
          .byte 0x34
          .byte 0x55
          .byte 0x5d
          .byte 0x5b
          .byte 0x45
          .byte 0x52
          .byte 0x52
          .byte 0x5d
          .byte 0x20
          .byte 0x72
          .byte 0x65
          .byte 0x73
          .byte 0x75
          .byte 0x6c
          .byte 0x74
          .byte 0x5f
          .byte 0x6d
          .byte 0x76
          .byte 0x61
          .byte 0x20
          .byte 0x3d
          .byte 0x20
          .byte 0x30
          .byte 0x78
          .byte 0x25
          .byte 0x78
          .byte 0x20
          .byte 0x69
          .byte 0x73
          .byte 0x20
          .byte 0x6e
          .byte 0x6f
          .byte 0x74
          .byte 0x20
          .byte 0x69
          .byte 0x6e
          .byte 0x20
          .byte 0x73
          .byte 0x74
          .byte 0x61
          .byte 0x67
          .byte 0x65
          .byte 0x20
          .byte 0x33
          .byte 0x2c
          .byte 0x20
          .byte 0x63
          .byte 0x61
          .byte 0x73
          .byte 0x65
          .byte 0x20
          .byte 0x66
          .byte 0x61
          .byte 0x69
          .byte 0x6c
          .byte 0x65
          .byte 0x64
          .byte 0x21
          .byte 0xa
          .byte 0x0
.L_ffffff8009337360:
          .string "[Pmaster]force trigger display path\r\n"
.L_ffffff8009337386:
          .byte 0x1
          .byte 0x36
.L_ffffff8009337388:
          .string "[ccci%d/Speed]%s new setting\r\n"
.L_ffffff80093373a7:
          .string "[%d]%s new setting\r\n"
.L_ffffff80093373bc:
          .byte 0x1
          .byte 0x30
          .byte 0x5b
          .byte 0x25
          .byte 0x73
          .byte 0x5d
          .byte 0x20
          .byte 0x66
          .byte 0x75
          .byte 0x6e
          .byte 0x63
          .byte 0x74
          .byte 0x69
          .byte 0x6f
          .byte 0x6e
          .byte 0x20
          .byte 0x3d
          .byte 0x20
          .byte 0x25
          .byte 0x2d
          .byte 0x33
          .byte 0x30
          .byte 0x73
          .byte 0x2c
          .byte 0x20
          .byte 0x6c
          .byte 0x69
          .byte 0x6e
          .byte 0x65
          .byte 0x20
          .byte 0x3d
          .byte 0x20
          .byte 0x25
          .byte 0x2d
          .byte 0x34
          .byte 0x64
          .byte 0x3a
          .byte 0x20
          .byte 0x73
          .byte 0x65
          .byte 0x6d
          .byte 0x69
          .byte 0x74
          .byte 0x6f
          .byte 0x75
          .byte 0x63
          .byte 0x68
          .byte 0x20
          .byte 0x72
          .byte 0x65
          .byte 0x6d
          .byte 0x6f
          .byte 0x76
          .byte 0x65
          .byte 0x20
          .byte 0x63
          .byte 0x6f
          .byte 0x6d
          .byte 0x70
          .byte 0x6c
          .byte 0x65
          .byte 0x74
          .byte 0x65
          .byte 0xd
          .byte 0xa
          .byte 0x0
.L_ffffff80093373fe:
          .string "aw9523b_key_report all release\r\n"
.L_ffffff800933741f:
          .string "TCPC-TYPEC:typec_new_role: %s is the same\r\n"
.L_ffffff800933744b:
          .byte 0x1
          .byte 0x36
          .byte 0x5b
          .byte 0x41
          .byte 0x55
          .byte 0x54
          .byte 0x4f
          .byte 0x4b
          .byte 0x5d
          .byte 0x57
          .byte 0x41
          .byte 0x52
          .byte 0x4e
          .byte 0x3a
          .byte 0x20
          .byte 0x54
          .byte 0x72
          .byte 0x79
          .byte 0x20
          .byte 0x74
          .byte 0x6f
          .byte 0x20
          .byte 0x66
          .byte 0x69
          .byte 0x6c
          .byte 0x74
          .byte 0x65
          .byte 0x72
          .byte 0x20
          .byte 0x74
          .byte 0x68
          .byte 0x65
          .byte 0x20
          .byte 0x68
          .byte 0x6f
          .byte 0x6c
          .byte 0x65
          .byte 0xd
          .byte 0xa
          .byte 0x0
.L_ffffff8009337473:
          .byte 0x1
          .byte 0x36
          .byte 0x5b
          .byte 0x41
          .byte 0x55
          .byte 0x54
          .byte 0x4f
          .byte 0x4b
          .byte 0x5d
          .byte 0x53
          .byte 0x44
          .byte 0x49
          .byte 0x4f
          .byte 0x20
          .byte 0x64
          .byte 0x65
          .byte 0x76
          .byte 0x69
          .byte 0x63
          .byte 0x65
          .byte 0x20
          .byte 0x66
          .byte 0x75
          .byte 0x6e
          .byte 0x63
          .byte 0x74
          .byte 0x69
          .byte 0x6f
          .byte 0x6e
          .byte 0x20
          .byte 0x65
          .byte 0x6e
          .byte 0x61
          .byte 0x62
          .byte 0x6c
          .byte 0x65
          .byte 0xd
          .byte 0xa
          .byte 0x0
.L_ffffff800933749a:
          .byte 0x1
          .byte 0x36
          .byte 0x5b
          .byte 0x41
          .byte 0x55
          .byte 0x54
          .byte 0x4f
          .byte 0x4b
          .byte 0x5d
          .byte 0x53
          .byte 0x44
          .byte 0x49
          .byte 0x4f
          .byte 0x20
          .byte 0x64
          .byte 0x65
          .byte 0x76
          .byte 0x20
          .byte 0x66
          .byte 0x75
          .byte 0x6e
          .byte 0x63
          .byte 0x20
          .byte 0x65
          .byte 0x6e
          .byte 0x61
          .byte 0x62
          .byte 0x6c
          .byte 0x65
          .byte 0xd
          .byte 0xa
          .byte 0x0
.align 3

__INIT
#-----------------------------------
.weak aw9523_i2c_init
.type aw9523_i2c_init, @function
#-----------------------------------
aw9523_i2c_init:

            stp fp,lr,[sp,#-32]!
            str x19,[sp,#16]
            mov fp,sp
            adrp x1, .L_ffffff8009a01c20
            add x1,x1, :lo12:.L_ffffff8009a01c20
            mov x0,xzr
            bl i2c_register_driver

            mov w19,w0
            cbz w0,.L_ffffff8009413a68

            adrp x0, .L_ffffff80092d536b
            add x0,x0, :lo12:.L_ffffff80092d536b
            bl printk
.L_ffffff8009413a68:

            mov w0,w19
            ldr x19,[sp,#16]
            ldp fp,lr,[sp],#32
            ret
.size aw9523_i2c_init, . - aw9523_i2c_init

.section .data
.L_ffffff8009a017c8:
          .byte 0x48
          .byte 0x9d
          .byte 0xfe
          .byte 0x8
          .byte 0x80
          .byte 0xff
          .byte 0xff
          .byte 0xff
          .zero 72
.L_ffffff8009a01818:
          .byte 0xd8
          .byte 0x9e
          .byte 0xfe
          .byte 0x8
          .byte 0x80
          .byte 0xff
          .byte 0xff
          .byte 0xff
          .zero 40
.L_ffffff8009a01848:
          .string "ENTER"
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x1c
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x4
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x2
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x4d
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x32
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x3
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x2
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x4e
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x31
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x2
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x2
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x42
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x30
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x1
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x2
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x53
          .byte 0x50
          .byte 0x41
          .byte 0x43
          .byte 0x45
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x39
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x2
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x56
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x2f
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x4
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x1
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x43
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x2e
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x3
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x1
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x58
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x2d
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x2
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x1
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x5a
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x2c
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x1
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x1
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x44
          .byte 0x45
          .byte 0x4c
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0xe
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x3
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x4
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x4c
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x26
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x2
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x4
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x4b
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x25
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x1
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x4
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x4a
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x24
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x4
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x48
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x23
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x4
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x3
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x47
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x22
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x3
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x3
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x46
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x21
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x2
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x3
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x44
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x20
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x1
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x3
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x53
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x1f
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x3
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x41
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x1e
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x1
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x50
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x19
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x4
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x4
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x4f
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x18
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x4
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x5
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x49
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x17
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x3
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x5
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x55
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x16
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x2
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x5
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x59
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x15
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x1
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x5
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x54
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x14
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x5
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x52
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x13
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x3
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x6
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x45
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x12
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x2
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x6
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x57
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x11
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x1
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x6
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x51
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x10
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x6
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x53
          .byte 0x59
          .byte 0x4d
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x7f
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x5
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x2
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x42
          .byte 0x41
          .byte 0x43
          .byte 0x4b
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x9e
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x5
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x3
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x4d
          .byte 0x45
          .byte 0x4e
          .byte 0x55
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x44
          .byte 0x2
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x5
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x4
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x53
          .byte 0x48
          .byte 0x49
          .byte 0x46
          .byte 0x54
          .byte 0x2d
          .byte 0x4c
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x2a
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x5
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x1
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x46
          .byte 0x31
          .byte 0x33
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0xb7
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x6
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x1
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x41
          .byte 0x4c
          .byte 0x54
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x64
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x7
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x1
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
.L_ffffff8009a01c20:
          .zero 16
.L_ffffff8009a01c30:
          .quad aw9523_i2c_probe
.L_ffffff8009a01c38:
          .quad aw9523_i2c_remove
          .zero 32
.L_ffffff8009a01c60:
          .quad .L_ffffff800915b9eb
          .zero 32
.L_ffffff8009a01c88:
          .byte 0x18
          .byte 0x9f
          .byte 0xfe
          .byte 0x8
          .byte 0x80
          .byte 0xff
          .byte 0xff
          .byte 0xff
          .zero 72
.L_ffffff8009a01cd8:
          .byte 0xa8
          .byte 0xa0
          .byte 0xfe
          .byte 0x8
          .byte 0x80
          .byte 0xff
          .byte 0xff
          .byte 0xff
          .zero 40
.L_ffffff8009a01d08:
          .quad .L_ffffff800919cbbc
          .byte 0xb0
          .byte 0x1
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
.L_ffffff8009a01d18:
          .quad aw9523_get_reg
.L_ffffff8009a01d20:
          .quad aw9523_set_reg
.L_ffffff8009a01d28:
          .byte 0x28
          .byte 0x83
          .byte 0x1b
          .byte 0x9
          .byte 0x80
          .byte 0xff
          .byte 0xff
          .byte 0xff
          .byte 0xff
          .byte 0xff
          .byte 0xff
          .byte 0xff
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
#===================================
# end section .data
#===================================

#===================================
.bss
#===================================

.L_ffffff800a24e548:
          .zero 400
# WARNING: found overlapping blocks at address ffffff800a24e548
.L_ffffff800a24e6d8:
          .zero 8
# WARNING: found overlapping blocks at address ffffff800a24e6d8
.L_ffffff800a24e6e0:
          .zero 8
# WARNING: found overlapping blocks at address ffffff800a24e6e0
.L_ffffff800a24e6e8:
          .zero 1
# WARNING: found overlapping blocks at address ffffff800a24e6e8
.L_ffffff800a24e6e9:
          .zero 1
# WARNING: found overlapping blocks at address ffffff800a24e6e9
.L_ffffff800a24e6ea:
          .zero 6
# WARNING: found overlapping blocks at address ffffff800a24e6ea
.L_ffffff800a24e6f0:
          .zero 16
# WARNING: found overlapping blocks at address ffffff800a24e6f0
.L_ffffff800a24e700:
          .zero 56
# WARNING: found overlapping blocks at address ffffff800a24e700
g_aw9523_data:
.L_ffffff800a24e738:
          .zero 8
# WARNING: found overlapping blocks at address ffffff800a24e738
.L_ffffff800a24e740:
          .zero 8
# WARNING: found overlapping blocks at address ffffff800a24e740
.L_ffffff800a24e748:
          .zero 24
# WARNING: found overlapping blocks at address ffffff800a24e748
.L_ffffff800a24e760:
          .zero 8
# WARNING: found overlapping blocks at address ffffff800a24e760
.L_ffffff800a24e768:
          .zero 8
# WARNING: found overlapping blocks at address ffffff800a24e768
.L_ffffff800a24e770:
          .zero 8
# WARNING: found overlapping blocks at address ffffff800a24e770
.L_ffffff800a24e778:
          .zero 8
# WARNING: found overlapping blocks at address ffffff800a24e778
.L_ffffff800a24e780:
          .zero 68
# WARNING: found overlapping blocks at address ffffff800a24e780
.L_ffffff800a24e7c4:
          .zero 4
# WARNING: found overlapping blocks at address ffffff800a24e7c4
.L_ffffff800a24e7c8:
          .zero 8
# WARNING: found overlapping blocks at address ffffff800a24e7c8
.L_ffffff800a24e7d0:
          .zero 8
# WARNING: found overlapping blocks at address ffffff800a24e7d0
.L_ffffff800a24e7d8:
          .zero 1280
# WARNING: found overlapping blocks at address ffffff800a24e7d8
.L_ffffff800a24efb8:
          .zero 112
# WARNING: found overlapping blocks at address ffffff800a24efb8
.L_ffffff800a24f028:
          .zero 8
# WARNING: found overlapping blocks at address ffffff800a24f028
.L_ffffff800a24f030:
          .zero 1
# WARNING: found overlapping blocks at address ffffff800a24f030
.L_ffffff800a24f031:
          .zero 1
# WARNING: found overlapping blocks at address ffffff800a24f031
.L_ffffff800a24f032:
          .zero 1
# WARNING: found overlapping blocks at address ffffff800a24f032
.L_ffffff800a24f033:
          .zero 1
# WARNING: found overlapping blocks at address ffffff800a24f033
.L_ffffff800a24f034:
          .zero 1
# WARNING: found overlapping blocks at address ffffff800a24f034
.L_ffffff800a24f035:
          .zero 1
# WARNING: found overlapping blocks at address ffffff800a24f035
.L_ffffff800a24f036:
          .zero 1
# WARNING: found overlapping blocks at address ffffff800a24f036
.L_ffffff800a24f037:
          .zero 1
# WARNING: found overlapping blocks at address ffffff800a24f037
.L_ffffff800a24f038:
          .zero 1
# WARNING: found overlapping blocks at address ffffff800a24f038
.L_ffffff800a24f039:
          .zero 1
# WARNING: found overlapping blocks at address ffffff800a24f039
.L_ffffff800a24f03a:
          .zero 1
# WARNING: found overlapping blocks at address ffffff800a24f03a
.L_ffffff800a24f03b:
          .zero 1
# WARNING: found overlapping blocks at address ffffff800a24f03b
.L_ffffff800a24f03c:
          .zero 1
# WARNING: found overlapping blocks at address ffffff800a24f03c
.L_ffffff800a24f03d:
          .zero 1
# WARNING: found overlapping blocks at address ffffff800a24f03d
.L_ffffff800a24f03e:
          .zero 1
# WARNING: found overlapping blocks at address ffffff800a24f03e
.L_ffffff800a24f03f:
          .zero 1
# WARNING: found overlapping blocks at address ffffff800a24f03f
.L_ffffff800a24f040:
          .zero 1
# WARNING: found overlapping blocks at address ffffff800a24f040
.L_ffffff800a24f041:
          .zero 1
# WARNING: found overlapping blocks at address ffffff800a24f041
.L_ffffff800a24f042:
          .zero 1
# WARNING: found overlapping blocks at address ffffff800a24f042
.L_ffffff800a24f043:
          .zero 1
# WARNING: found overlapping blocks at address ffffff800a24f043
.L_ffffff800a24f044:
          .zero 1
# WARNING: found overlapping blocks at address ffffff800a24f044
.L_ffffff800a24f045:
          .zero 1
# WARNING: found overlapping blocks at address ffffff800a24f045
.L_ffffff800a24f046:
          .zero 1
# WARNING: found overlapping blocks at address ffffff800a24f046
.L_ffffff800a24f047:
          .zero 1
# WARNING: found overlapping blocks at address ffffff800a24f047
.L_ffffff800a24f048:
          .zero 1
# WARNING: found overlapping blocks at address ffffff800a24f048
.L_ffffff800a24f049:
          .zero 7
# WARNING: found overlapping blocks at address ffffff800a24f049
.L_ffffff800a24f050:
          .zero 8
# WARNING: found overlapping blocks at address ffffff800a24f050
.L_ffffff800a24f058:
          .zero 4
# WARNING: found overlapping blocks at address ffffff800a24f058
.L_ffffff800a24f05c:
          .zero 12
# WARNING: found overlapping blocks at address ffffff800a24f05c
.L_ffffff800a24f068:
          .zero 4
# WARNING: found overlapping blocks at address ffffff800a24f068
.L_ffffff800a24f06c:
          .zero 4
# WARNING: found overlapping blocks at address ffffff800a24f06c
.L_ffffff800a24f070:
          .zero 8
# WARNING: found overlapping blocks at address ffffff800a24f070
.L_ffffff800a24f078:
          .zero 8
# WARNING: found overlapping blocks at address ffffff800a24f078
.L_ffffff800a24f080:
          .zero 1
# WARNING: found overlapping blocks at address ffffff800a24f080
.L_ffffff800a24f081:
          .zero 7
# WARNING: found overlapping blocks at address ffffff800a24f081
.L_ffffff800a24f088:
          .zero 32
# WARNING: found overlapping blocks at address ffffff800a24f088
.L_ffffff800a24f0a8:
          .zero 16
# WARNING: found overlapping blocks at address ffffff800a24f0a8
.L_ffffff800a24f0b8:
          .zero 112
# WARNING: found overlapping blocks at address ffffff800a24f0b8
#===================================
# end section .bss
#===================================
