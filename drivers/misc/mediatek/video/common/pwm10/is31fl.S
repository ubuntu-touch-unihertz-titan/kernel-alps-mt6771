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
.globl agold_is31fl_write_byte
.type agold_is31fl_write_byte, @function
#-----------------------------------
agold_is31fl_write_byte:

            sub sp,sp,#48
            stp fp,lr,[sp,#32]
            add fp,sp,#32
            adrp x8, __stack_chk_guard
            ldr x8,[x8,:lo12:__stack_chk_guard]
            mov w9,#108
            mov w10,#2
            mov w2,#1
            stur x8,[fp,#-8]
            adrp x8, .L_ffffff800a1328b0
            ldr x8,[x8,:lo12:.L_ffffff800a1328b0]
            str w9,[sp,#8]
            add x9,sp,#4
            strb w0,[sp,#4]
            strb w1,[sp,#5]
            strh w10,[sp,#12]
            str x9,[sp,#16]
            ldr x0,[x8,#24]
            add x1,sp,#8
            bl i2c_transfer

            tbz w0,#31,.L_ffffff80089234a4

            adrp x0, .L_ffffff800933474d
            add x0,x0, :lo12:.L_ffffff800933474d
            bl printk
.L_ffffff80089234a4:

            adrp x9, __stack_chk_guard
            ldur x8,[fp,#-8]
            ldr x9,[x9,:lo12:__stack_chk_guard]
            cmp x9,x8
            b.ne .L_ffffff80089234c8

            ldp fp,lr,[sp,#32]
            mov w0,wzr
            add sp,sp,#48
            ret
.L_ffffff80089234c8:

            bl __stack_chk_fail
.size agold_is31fl_write_byte, . - agold_is31fl_write_byte
.align 2
#-----------------------------------
.globl agold_is31fl_write_buff
.type agold_is31fl_write_buff, @function
#-----------------------------------
agold_is31fl_write_buff:

            sub sp,sp,#64
            stp fp,lr,[sp,#48]
            add fp,sp,#48
            adrp x8, __stack_chk_guard
            ldr x8,[x8,:lo12:__stack_chk_guard]
            and x9,x1,#255
            mov x10,#72340172838076673
            mul x9,x9,x10
            stur x8,[fp,#-8]
            mov w8,#108
            str w8,[sp,#8]
            adrp x8, .L_ffffff800a1328b0
            ldr x8,[x8,:lo12:.L_ffffff800a1328b0]
            mov w10,#13
            stur x9,[sp,#25]
            stur w9,[sp,#33]
            add x9,sp,#24
            strb w0,[sp,#24]
            strh w10,[sp,#12]
            str x9,[sp,#16]
            ldr x0,[x8,#24]
            add x1,sp,#8
            mov w2,#1
            bl i2c_transfer

            tbz w0,#31,.L_ffffff800892353c

            adrp x0, .L_ffffff800933474d
            add x0,x0, :lo12:.L_ffffff800933474d
            bl printk
.L_ffffff800892353c:

            adrp x9, __stack_chk_guard
            ldur x8,[fp,#-8]
            ldr x9,[x9,:lo12:__stack_chk_guard]
            cmp x9,x8
            b.ne .L_ffffff8008923560

            ldp fp,lr,[sp,#48]
            mov w0,wzr
            add sp,sp,#64
            ret
.L_ffffff8008923560:

            bl __stack_chk_fail
.size agold_is31fl_write_buff, . - agold_is31fl_write_buff
.align 2
#-----------------------------------
.globl agold_is31fl_read
.type agold_is31fl_read, @function
#-----------------------------------
agold_is31fl_read:

            sub sp,sp,#96
            stp fp,lr,[sp,#32]
            str x23,[sp,#48]
            stp x22,x21,[sp,#64]
            stp x20,x19,[sp,#80]
            add fp,sp,#32
            adrp x8, __stack_chk_guard
            ldr x8,[x8,:lo12:__stack_chk_guard]
            adrp x19, .L_ffffff800a1328b8
            adrp x23, .L_ffffff800a1328b0
            mov w9,#4
            stur x8,[fp,#-8]
            ldr w8,[x19,:lo12:.L_ffffff800a1328b8]
            mov w20,#108
            mov w21,#2
            add x22,sp,#4
            strb w8,[sp,#5]
            ldr x8,[x23,:lo12:.L_ffffff800a1328b0]
            strb w9,[sp,#4]
            str w20,[sp,#8]
            strh w21,[sp,#12]
            str x22,[sp,#16]
            ldr x0,[x8,#24]
            add x1,sp,#8
            mov w2,#1
            bl i2c_transfer

            tbz w0,#31,.L_ffffff80089235dc

            adrp x0, .L_ffffff800933474d
            add x0,x0, :lo12:.L_ffffff800933474d
            bl printk
.L_ffffff80089235dc:

            ldr x9,[x23,:lo12:.L_ffffff800a1328b0]
            mov w8,#19
            strh w8,[sp,#4]
            str w20,[sp,#8]
            strh w21,[sp,#12]
            str x22,[sp,#16]
            ldr x0,[x9,#24]
            add x1,sp,#8
            mov w2,#1
            bl i2c_transfer

            tbz w0,#31,.L_ffffff8008923614

            adrp x0, .L_ffffff800933474d
            add x0,x0, :lo12:.L_ffffff800933474d
            bl printk
.L_ffffff8008923614:

            ldr w2,[x19,:lo12:.L_ffffff800a1328b8]
            adrp x0, .L_ffffff800915f020
            adrp x1, .L_ffffff80091b8de3
            add x0,x0, :lo12:.L_ffffff800915f020
            add x1,x1, :lo12:.L_ffffff80091b8de3
            bl printk

            ldr w8,[x19,:lo12:.L_ffffff800a1328b8]
            adrp x9, __stack_chk_guard
            ldr x9,[x9,:lo12:__stack_chk_guard]
            add w8,w8,#1
            str w8,[x19,:lo12:.L_ffffff800a1328b8]
            ldur x8,[fp,#-8]
            cmp x9,x8
            b.ne .L_ffffff8008923668

            ldp x20,x19,[sp,#80]
            ldp x22,x21,[sp,#64]
            ldr x23,[sp,#48]
            ldp fp,lr,[sp,#32]
            mov x0,xzr
            add sp,sp,#96
            ret
.L_ffffff8008923668:

            bl __stack_chk_fail
.size agold_is31fl_read, . - agold_is31fl_read
.align 2
#-----------------------------------
.globl agold_is31fl_bled
.type agold_is31fl_bled, @function
#-----------------------------------
agold_is31fl_bled:

            sub sp,sp,#112
            stp fp,lr,[sp,#48]
            str x23,[sp,#64]
            stp x22,x21,[sp,#80]
            stp x20,x19,[sp,#96]
            add fp,sp,#48
            adrp x8, __stack_chk_guard
            ldr x8,[x8,:lo12:__stack_chk_guard]
            adrp x20, .L_ffffff800a1328bc
            cmp w0,#0
            stur x8,[fp,#-8]
            ldr w9,[x20,:lo12:.L_ffffff800a1328bc]
            add w8,w0,#3
            csel w8,w8,w0,lt
            asr w8,w8,#2
            cmp w9,w8
            b.eq .L_ffffff8008923e28

            cmp w0,#119
            adrp x19, .L_ffffff800a1328b0
            mov w9,#4
            str w8,[x20,:lo12:.L_ffffff800a1328bc]
            b.gt .L_ffffff8008923d98

            strb w8,[sp,#25]
            ldr x8,[x19,:lo12:.L_ffffff800a1328b0]
            mov w21,#108
            mov w22,#2
            add x23,sp,#24
            strb w9,[sp,#24]
            str w21,[sp,#8]
            strh w22,[sp,#12]
            str x23,[sp,#16]
            ldr x0,[x8,#24]
            add x1,sp,#8
            mov w2,#1
            bl i2c_transfer

            tbz w0,#31,.L_ffffff8008923708

            adrp x0, .L_ffffff800933474d
            add x0,x0, :lo12:.L_ffffff800933474d
            bl printk
.L_ffffff8008923708:

            ldr w8,[x20,:lo12:.L_ffffff800a1328bc]
            ldr x10,[x19,:lo12:.L_ffffff800a1328b0]
            mov w9,#5
            str w21,[sp,#8]
            strh w22,[sp,#12]
            strb w9,[sp,#24]
            strb w8,[sp,#25]
            str x23,[sp,#16]
            ldr x0,[x10,#24]
            add x1,sp,#8
            mov w2,#1
            bl i2c_transfer

            tbz w0,#31,.L_ffffff8008923748

            adrp x0, .L_ffffff800933474d
            add x0,x0, :lo12:.L_ffffff800933474d
            bl printk
.L_ffffff8008923748:

            ldr w8,[x20,:lo12:.L_ffffff800a1328bc]
            ldr x10,[x19,:lo12:.L_ffffff800a1328b0]
            mov w9,#6
            mov w22,#108
            mov w23,#2
            add x21,sp,#24
            strb w9,[sp,#24]
            str w22,[sp,#8]
            strh w23,[sp,#12]
            strb w8,[sp,#25]
            str x21,[sp,#16]
            ldr x0,[x10,#24]
            add x1,sp,#8
            mov w2,#1
            bl i2c_transfer

            tbz w0,#31,.L_ffffff8008923794

            adrp x0, .L_ffffff800933474d
            add x0,x0, :lo12:.L_ffffff800933474d
            bl printk
.L_ffffff8008923794:

            ldr w8,[x20,:lo12:.L_ffffff800a1328bc]
            ldr x10,[x19,:lo12:.L_ffffff800a1328b0]
            mov w9,#7
            str w22,[sp,#8]
            strh w23,[sp,#12]
            strb w9,[sp,#24]
            strb w8,[sp,#25]
            str x21,[sp,#16]
            ldr x0,[x10,#24]
            add x1,sp,#8
            mov w2,#1
            bl i2c_transfer

            tbz w0,#31,.L_ffffff80089237d4

            adrp x0, .L_ffffff800933474d
            add x0,x0, :lo12:.L_ffffff800933474d
            bl printk
.L_ffffff80089237d4:

            ldr x9,[x19,:lo12:.L_ffffff800a1328b0]
            mov w8,#19
            mov w21,#108
            mov w22,#2
            add x23,sp,#24
            strh w8,[sp,#24]
            str w21,[sp,#8]
            strh w22,[sp,#12]
            str x23,[sp,#16]
            ldr x0,[x9,#24]
            add x1,sp,#8
            mov w2,#1
            bl i2c_transfer

            tbz w0,#31,.L_ffffff8008923818

            adrp x0, .L_ffffff800933474d
            add x0,x0, :lo12:.L_ffffff800933474d
            bl printk
.L_ffffff8008923818:

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            ldr w8,[x20,:lo12:.L_ffffff800a1328bc]
            ldr x10,[x19,:lo12:.L_ffffff800a1328b0]
            mov w9,#8
            str w21,[sp,#8]
            strh w22,[sp,#12]
            strb w9,[sp,#24]
            strb w8,[sp,#25]
            str x23,[sp,#16]
            ldr x0,[x10,#24]
            add x1,sp,#8
            mov w2,#1
            bl i2c_transfer

            tbz w0,#31,.L_ffffff8008923948

            adrp x0, .L_ffffff800933474d
            add x0,x0, :lo12:.L_ffffff800933474d
            bl printk
.L_ffffff8008923948:

            ldr w8,[x20,:lo12:.L_ffffff800a1328bc]
            ldr x10,[x19,:lo12:.L_ffffff800a1328b0]
            mov w9,#9
            mov w22,#108
            mov w23,#2
            add x21,sp,#24
            strb w9,[sp,#24]
            str w22,[sp,#8]
            strh w23,[sp,#12]
            strb w8,[sp,#25]
            str x21,[sp,#16]
            ldr x0,[x10,#24]
            add x1,sp,#8
            mov w2,#1
            bl i2c_transfer

            tbz w0,#31,.L_ffffff8008923994

            adrp x0, .L_ffffff800933474d
            add x0,x0, :lo12:.L_ffffff800933474d
            bl printk
.L_ffffff8008923994:

            ldr w8,[x20,:lo12:.L_ffffff800a1328bc]
            ldr x10,[x19,:lo12:.L_ffffff800a1328b0]
            mov w9,#10
            str w22,[sp,#8]
            strh w23,[sp,#12]
            strb w9,[sp,#24]
            strb w8,[sp,#25]
            str x21,[sp,#16]
            ldr x0,[x10,#24]
            add x1,sp,#8
            mov w2,#1
            bl i2c_transfer

            tbz w0,#31,.L_ffffff80089239d4

            adrp x0, .L_ffffff800933474d
            add x0,x0, :lo12:.L_ffffff800933474d
            bl printk
.L_ffffff80089239d4:

            ldr w8,[x20,:lo12:.L_ffffff800a1328bc]
            ldr x10,[x19,:lo12:.L_ffffff800a1328b0]
            mov w9,#11
            mov w21,#108
            mov w22,#2
            add x23,sp,#24
            strb w9,[sp,#24]
            str w21,[sp,#8]
            strh w22,[sp,#12]
            strb w8,[sp,#25]
            str x23,[sp,#16]
            ldr x0,[x10,#24]
            add x1,sp,#8
            mov w2,#1
            bl i2c_transfer

            tbz w0,#31,.L_ffffff8008923a20

            adrp x0, .L_ffffff800933474d
            add x0,x0, :lo12:.L_ffffff800933474d
            bl printk
.L_ffffff8008923a20:

            ldr x9,[x19,:lo12:.L_ffffff800a1328b0]
            mov w8,#19
            strh w8,[sp,#24]
            str w21,[sp,#8]
            strh w22,[sp,#12]
            str x23,[sp,#16]
            ldr x0,[x9,#24]
            add x1,sp,#8
            mov w2,#1
            bl i2c_transfer

            tbz w0,#31,.L_ffffff8008923a58

            adrp x0, .L_ffffff800933474d
            add x0,x0, :lo12:.L_ffffff800933474d
            bl printk
.L_ffffff8008923a58:

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            ldr w8,[x20,:lo12:.L_ffffff800a1328bc]
            ldr x10,[x19,:lo12:.L_ffffff800a1328b0]
            mov w9,#12
            mov w22,#108
            mov w23,#2
            add x21,sp,#24
            strb w9,[sp,#24]
            str w22,[sp,#8]
            strh w23,[sp,#12]
            strb w8,[sp,#25]
            str x21,[sp,#16]
            ldr x0,[x10,#24]
            add x1,sp,#8
            mov w2,#1
            bl i2c_transfer

            tbz w0,#31,.L_ffffff8008923b94

            adrp x0, .L_ffffff800933474d
            add x0,x0, :lo12:.L_ffffff800933474d
            bl printk
.L_ffffff8008923b94:

            ldr w8,[x20,:lo12:.L_ffffff800a1328bc]
            ldr x10,[x19,:lo12:.L_ffffff800a1328b0]
            mov w9,#13
            str w22,[sp,#8]
            strh w23,[sp,#12]
            strb w9,[sp,#24]
            strb w8,[sp,#25]
            str x21,[sp,#16]
            ldr x0,[x10,#24]
            add x1,sp,#8
            mov w2,#1
            bl i2c_transfer

            tbz w0,#31,.L_ffffff8008923bd4

            adrp x0, .L_ffffff800933474d
            add x0,x0, :lo12:.L_ffffff800933474d
            bl printk
.L_ffffff8008923bd4:

            ldr w8,[x20,:lo12:.L_ffffff800a1328bc]
            ldr x10,[x19,:lo12:.L_ffffff800a1328b0]
            mov w9,#14
            mov w22,#108
            mov w23,#2
            add x21,sp,#24
            strb w9,[sp,#24]
            str w22,[sp,#8]
            strh w23,[sp,#12]
            strb w8,[sp,#25]
            str x21,[sp,#16]
            ldr x0,[x10,#24]
            add x1,sp,#8
            mov w2,#1
            bl i2c_transfer

            tbz w0,#31,.L_ffffff8008923c20

            adrp x0, .L_ffffff800933474d
            add x0,x0, :lo12:.L_ffffff800933474d
            bl printk
.L_ffffff8008923c20:

            ldr w8,[x20,:lo12:.L_ffffff800a1328bc]
            ldr x10,[x19,:lo12:.L_ffffff800a1328b0]
            mov w9,#15
            str w22,[sp,#8]
            strh w23,[sp,#12]
            strb w9,[sp,#24]
            strb w8,[sp,#25]
            str x21,[sp,#16]
            ldr x0,[x10,#24]
            add x1,sp,#8
            mov w2,#1
            bl i2c_transfer

            tbz w0,#31,.L_ffffff8008923c60

            adrp x0, .L_ffffff800933474d
            add x0,x0, :lo12:.L_ffffff800933474d
            bl printk
.L_ffffff8008923c60:

            ldr x11,[x19,:lo12:.L_ffffff800a1328b0]
            mov w8,#19
            mov w9,#108
            mov w10,#2
            strh w8,[sp,#24]
            add x8,sp,#24
            str w9,[sp,#8]
            strh w10,[sp,#12]
            str x8,[sp,#16]
            ldr x0,[x11,#24]
            add x1,sp,#8
            mov w2,#1
            bl i2c_transfer

            tbz w0,#31,.L_ffffff8008923ca4

            adrp x0, .L_ffffff800933474d
            add x0,x0, :lo12:.L_ffffff800933474d
            bl printk
.L_ffffff8008923ca4:

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            mov w0,#35160
            movk w0,#65,lsl #16
            bl __const_udelay

            b .L_ffffff8008923e28
.L_ffffff8008923d98:

            ldr x12,[x19,:lo12:.L_ffffff800a1328b0]
            and x8,x8,#255
            mov x10,#72340172838076673
            mov w20,#108
            mov w11,#13
            mul x8,x8,x10
            add x21,sp,#24
            strb w9,[sp,#24]
            str w20,[sp,#8]
            strh w11,[sp,#12]
            stur x8,[sp,#25]
            stur w8,[sp,#33]
            str x21,[sp,#16]
            ldr x0,[x12,#24]
            add x1,sp,#8
            mov w2,#1
            bl i2c_transfer

            tbz w0,#31,.L_ffffff8008923dec

            adrp x0, .L_ffffff800933474d
            add x0,x0, :lo12:.L_ffffff800933474d
            bl printk
.L_ffffff8008923dec:

            ldr x9,[x19,:lo12:.L_ffffff800a1328b0]
            mov w8,#19
            strh w8,[sp,#24]
            mov w8,#2
            str w20,[sp,#8]
            strh w8,[sp,#12]
            str x21,[sp,#16]
            ldr x0,[x9,#24]
            add x1,sp,#8
            mov w2,#1
            bl i2c_transfer

            tbz w0,#31,.L_ffffff8008923e28

            adrp x0, .L_ffffff800933474d
            add x0,x0, :lo12:.L_ffffff800933474d
            bl printk
.L_ffffff8008923e28:

            adrp x9, __stack_chk_guard
            ldur x8,[fp,#-8]
            ldr x9,[x9,:lo12:__stack_chk_guard]
            cmp x9,x8
            b.ne .L_ffffff8008923e58

            ldp x20,x19,[sp,#96]
            ldp x22,x21,[sp,#80]
            ldr x23,[sp,#64]
            ldp fp,lr,[sp,#48]
            mov w0,wzr
            add sp,sp,#112
            ret
.L_ffffff8008923e58:

            bl __stack_chk_fail
.size agold_is31fl_bled, . - agold_is31fl_bled
.align 2
#-----------------------------------
.globl is31fl_i2c_probe
.type is31fl_i2c_probe, @function
#-----------------------------------
is31fl_i2c_probe:

            stp fp,lr,[sp,#-16]!
            mov fp,sp
            adrp x8, .L_ffffff800a1328b0
            str x0,[x8,:lo12:.L_ffffff800a1328b0]
            adrp x0, .L_ffffff8009190385
            adrp x3, .L_ffffff8008fdbc10
            add x0,x0, :lo12:.L_ffffff8009190385
            add x3,x3, :lo12:.L_ffffff8008fdbc10
            mov w1,#420
            mov x2,xzr
            bl proc_create

            adrp x0, .L_ffffff8009255354
            add x0,x0, :lo12:.L_ffffff8009255354
            bl printk

            mov w0,wzr
            ldp fp,lr,[sp],#16
            ret
.size is31fl_i2c_probe, . - is31fl_i2c_probe
.align 4
#-----------------------------------
.globl is31fl_i2c_remove
.type is31fl_i2c_remove, @function
#-----------------------------------
is31fl_i2c_remove:

            mov w0,wzr
            ret
.size is31fl_i2c_remove, . - is31fl_i2c_remove
.align 3
#-----------------------------------
.type agold_is31fl_write, @function
#-----------------------------------
agold_is31fl_write:

            mov x0,x2
            ret
.size agold_is31fl_write, . - agold_is31fl_write
#===================================
# end section .text
#===================================

#===================================
.section .data
#===================================
.align 8
.L_ffffff8008fdbc10:
          .zero 16
.L_ffffff800915f020:
          .string "cwe**%s,0x%x"
.L_ffffff8009190385:
          .ascii "agold_"
.L_ffffff80091b8de3:
          .string "agold_is31fl_read"
.L_ffffff8009255220:
          .string "is31fl_i2c_init enter\n"
.L_ffffff8009255354:
          .string "is31fl_i2c_probe enter\n"
.L_ffffff800933474d:
          .string "chenwei** is31fl_write_byte fail!!!\n"
#===================================
# end section .data
#===================================

#===================================
.bss
#===================================
.align 8
.L_ffffff800a1328b0:
          .zero 8
.L_ffffff800a1328b8:
          .zero 4
.L_ffffff800a1328bc:
          .zero 4
#===================================
# end section .bss
#===================================
