#include <linux/errno.h>
#include <linux/linkage.h>
#include <asm/asm-offsets.h>
#include <asm/assembler.h>

fp	.req	x29		// frame pointer register

#===================================
.section .text
#===================================

.align 2
#-----------------------------------
.globl lcm_set_util_funcs
.type lcm_set_util_funcs, @function
#-----------------------------------
lcm_set_util_funcs:

            stp fp,lr,[sp,#-16]!
            mov fp,sp
            mov x1,x0
            adrp x0, .L_ffffff800a108de8
            add x0,x0, :lo12:.L_ffffff800a108de8
            mov w2,#248
            bl __pi_memcpy

            ldp fp,lr,[sp],#16
            ret
.size lcm_set_util_funcs, . - lcm_set_util_funcs
.align 3
#-----------------------------------
.globl lcm_get_params
.type lcm_get_params, @function
#-----------------------------------
lcm_get_params:

            stp fp,lr,[sp,#-32]!
            str x19,[sp,#16]
            mov fp,sp
            mov w2,#1296
            mov w1,wzr
            mov x19,x0
            bl __pi_memset

            mov x9,#768
            mov x11,#52
            mov w8,#2
            movk x9,#1280,lsl #32
            add x10,x19,#1204
            movk x11,#93,lsl #32
            str x9,[x19,#24]
            add x9,x19,#484
            str w8,[x19]
            str x11,[x10]
            mov w10,#3
            str x10,[x9]
            str wzr,[x9,#432]
            str w10,[x19,#520]
            mov x10,#3
            movk x10,#4,lsl #32
            mov w9,#256
            str w8,[x19,#88]
            str w8,[x19,#528]
            mov x8,#1280
            str x10,[x19,#544]
            mov x10,#30
            mov w11,#4
            str w9,[x19,#536]
            mov w9,#9
            movk x8,#12,lsl #32
            movk x10,#100,lsl #32
            str w9,[x19,#552]
            mov w9,#768
            str x8,[x19,#560]
            mov w8,#230
            str x10,[x19,#568]
            mov w10,#1
            stp x11,xzr,[x19,#504]
            str w9,[x19,#580]
            str w8,[x19,#680]
            str w10,[x19,#700]
            ldr x19,[sp,#16]
            ldp fp,lr,[sp],#32
            ret
.size lcm_get_params, . - lcm_get_params
.align 2
#-----------------------------------
.globl lcm_init
.type lcm_init, @function
#-----------------------------------
lcm_init:

            stp fp,lr,[sp,#-32]!
            str x19,[sp,#16]
            mov fp,sp
            adrp x0, .L_ffffff80092551f7
            add x0,x0, :lo12:.L_ffffff80092551f7
            bl printk

            adrp x19, .L_ffffff800a108de8
            add x19,x19, :lo12:.L_ffffff800a108de8
            ldr x8,[x19]
            mov w0,wzr
            blr x8

            ldr x8,[x19,#40]
            mov w0,#4
            blr x8

            ldr x8,[x19]
            mov w0,#1
            blr x8

            ldr x8,[x19,#40]
            mov w0,#8
            blr x8

            adrp x8, .L_ffffff80099ec1e0
            ldr w1,[x8,:lo12:.L_ffffff80099ec1e0]
            adrp x19, .L_ffffff800a108e10
            cmp w1,#4095
            b.eq .L_ffffff8008858874

            cmp w1,#4094
            b.ne .L_ffffff8008858854

            adrp x9, .L_ffffff80099ec1e4
            ldr x8,[x19,:lo12:.L_ffffff800a108e10]
            ldrb w0,[x9,:lo12:.L_ffffff80099ec1e4]
            blr x8

            b .L_ffffff8008858874
.L_ffffff8008858854:

            adrp x3, .L_ffffff80099ec1e4
            adrp x8, .L_ffffff800a108eb0
            add x3,x3, :lo12:.L_ffffff80099ec1e4
            ldr x8,[x8,:lo12:.L_ffffff800a108eb0]
            ldrb w2,[x3],#1
            mov w4,#1
            mov x0,xzr
            blr x8
.L_ffffff8008858874:

            adrp x8, .L_ffffff80099ec228
            ldr w1,[x8,:lo12:.L_ffffff80099ec228]
            cmp w1,#4095
            b.eq .L_ffffff80088588c0

            cmp w1,#4094
            b.ne .L_ffffff80088588a0

            adrp x9, .L_ffffff80099ec22c
            ldr x8,[x19,:lo12:.L_ffffff800a108e10]
            ldrb w0,[x9,:lo12:.L_ffffff80099ec22c]
            blr x8

            b .L_ffffff80088588c0
.L_ffffff80088588a0:

            adrp x3, .L_ffffff80099ec22c
            adrp x8, .L_ffffff800a108eb0
            add x3,x3, :lo12:.L_ffffff80099ec22c
            ldr x8,[x8,:lo12:.L_ffffff800a108eb0]
            ldrb w2,[x3],#1
            mov w4,#1
            mov x0,xzr
            blr x8
.L_ffffff80088588c0:

            adrp x8, .L_ffffff80099ec270
            ldr w1,[x8,:lo12:.L_ffffff80099ec270]
            cmp w1,#4095
            b.eq .L_ffffff800885890c

            cmp w1,#4094
            b.ne .L_ffffff80088588ec

            adrp x9, .L_ffffff80099ec274
            ldr x8,[x19,:lo12:.L_ffffff800a108e10]
            ldrb w0,[x9,:lo12:.L_ffffff80099ec274]
            blr x8

            b .L_ffffff800885890c
.L_ffffff80088588ec:

            adrp x3, .L_ffffff80099ec274
            adrp x8, .L_ffffff800a108eb0
            add x3,x3, :lo12:.L_ffffff80099ec274
            ldr x8,[x8,:lo12:.L_ffffff800a108eb0]
            ldrb w2,[x3],#1
            mov w4,#1
            mov x0,xzr
            blr x8
.L_ffffff800885890c:

            adrp x8, .L_ffffff80099ec2b8
            ldr w1,[x8,:lo12:.L_ffffff80099ec2b8]
            cmp w1,#4095
            b.eq .L_ffffff8008858958

            cmp w1,#4094
            b.ne .L_ffffff8008858938

            adrp x9, .L_ffffff80099ec2bc
            ldr x8,[x19,:lo12:.L_ffffff800a108e10]
            ldrb w0,[x9,:lo12:.L_ffffff80099ec2bc]
            blr x8

            b .L_ffffff8008858958
.L_ffffff8008858938:

            adrp x3, .L_ffffff80099ec2bc
            adrp x8, .L_ffffff800a108eb0
            add x3,x3, :lo12:.L_ffffff80099ec2bc
            ldr x8,[x8,:lo12:.L_ffffff800a108eb0]
            ldrb w2,[x3],#1
            mov w4,#1
            mov x0,xzr
            blr x8
.L_ffffff8008858958:

            ldr x8,[x19,:lo12:.L_ffffff800a108e10]
            mov w0,#10
            blr x8

            ldr x19,[sp,#16]
            ldp fp,lr,[sp],#32
            ret
.size lcm_init, . - lcm_init
.align 4
#-----------------------------------
.globl lcm_suspend
.type lcm_suspend, @function
#-----------------------------------
lcm_suspend:

            stp fp,lr,[sp,#-32]!
            str x19,[sp,#16]
            mov fp,sp
            adrp x0, .L_ffffff800925536c
            add x0,x0, :lo12:.L_ffffff800925536c
            bl printk

            adrp x8, .L_ffffff80099ec300
            ldr w1,[x8,:lo12:.L_ffffff80099ec300]
            cmp w1,#4095
            b.eq .L_ffffff80088589d8

            cmp w1,#4094
            b.ne .L_ffffff80088589b8

            adrp x8, .L_ffffff800a108e10
            adrp x9, .L_ffffff80099ec304
            ldr x8,[x8,:lo12:.L_ffffff800a108e10]
            ldrb w0,[x9,:lo12:.L_ffffff80099ec304]
            blr x8

            b .L_ffffff80088589d8
.L_ffffff80088589b8:

            adrp x3, .L_ffffff80099ec304
            adrp x8, .L_ffffff800a108eb0
            add x3,x3, :lo12:.L_ffffff80099ec304
            ldr x8,[x8,:lo12:.L_ffffff800a108eb0]
            ldrb w2,[x3],#1
            mov w4,#1
            mov x0,xzr
            blr x8
.L_ffffff80088589d8:

            adrp x8, .L_ffffff80099ec348
            ldr w1,[x8,:lo12:.L_ffffff80099ec348]
            cmp w1,#4095
            b.eq .L_ffffff8008858a28

            cmp w1,#4094
            b.ne .L_ffffff8008858a08

            adrp x8, .L_ffffff800a108e10
            adrp x9, .L_ffffff80099ec34c
            ldr x8,[x8,:lo12:.L_ffffff800a108e10]
            ldrb w0,[x9,:lo12:.L_ffffff80099ec34c]
            blr x8

            b .L_ffffff8008858a28
.L_ffffff8008858a08:

            adrp x3, .L_ffffff80099ec34c
            adrp x8, .L_ffffff800a108eb0
            add x3,x3, :lo12:.L_ffffff80099ec34c
            ldr x8,[x8,:lo12:.L_ffffff800a108eb0]
            ldrb w2,[x3],#1
            mov w4,#1
            mov x0,xzr
            blr x8
.L_ffffff8008858a28:

            adrp x8, .L_ffffff80099ec390
            ldr w1,[x8,:lo12:.L_ffffff80099ec390]
            cmp w1,#4095
            b.eq .L_ffffff8008858a78

            cmp w1,#4094
            b.ne .L_ffffff8008858a58

            adrp x8, .L_ffffff800a108e10
            adrp x9, .L_ffffff80099ec394
            ldr x8,[x8,:lo12:.L_ffffff800a108e10]
            ldrb w0,[x9,:lo12:.L_ffffff80099ec394]
            blr x8

            b .L_ffffff8008858a78
.L_ffffff8008858a58:

            adrp x3, .L_ffffff80099ec394
            adrp x8, .L_ffffff800a108eb0
            add x3,x3, :lo12:.L_ffffff80099ec394
            ldr x8,[x8,:lo12:.L_ffffff800a108eb0]
            ldrb w2,[x3],#1
            mov w4,#1
            mov x0,xzr
            blr x8
.L_ffffff8008858a78:

            adrp x8, .L_ffffff80099ec3d8
            ldr w1,[x8,:lo12:.L_ffffff80099ec3d8]
            cmp w1,#4095
            b.eq .L_ffffff8008858ac8

            cmp w1,#4094
            b.ne .L_ffffff8008858aa8

            adrp x8, .L_ffffff800a108e10
            adrp x9, .L_ffffff80099ec3dc
            ldr x8,[x8,:lo12:.L_ffffff800a108e10]
            ldrb w0,[x9,:lo12:.L_ffffff80099ec3dc]
            blr x8

            b .L_ffffff8008858ac8
.L_ffffff8008858aa8:

            adrp x3, .L_ffffff80099ec3dc
            adrp x8, .L_ffffff800a108eb0
            add x3,x3, :lo12:.L_ffffff80099ec3dc
            ldr x8,[x8,:lo12:.L_ffffff800a108eb0]
            ldrb w2,[x3],#1
            mov w4,#1
            mov x0,xzr
            blr x8
.L_ffffff8008858ac8:

            adrp x8, .L_ffffff80099ec420
            ldr w1,[x8,:lo12:.L_ffffff80099ec420]
            cmp w1,#4095
            b.eq .L_ffffff8008858b18

            cmp w1,#4094
            b.ne .L_ffffff8008858af8

            adrp x8, .L_ffffff800a108e10
            adrp x9, .L_ffffff80099ec424
            ldr x8,[x8,:lo12:.L_ffffff800a108e10]
            ldrb w0,[x9,:lo12:.L_ffffff80099ec424]
            blr x8

            b .L_ffffff8008858b18
.L_ffffff8008858af8:

            adrp x3, .L_ffffff80099ec424
            adrp x8, .L_ffffff800a108eb0
            add x3,x3, :lo12:.L_ffffff80099ec424
            ldr x8,[x8,:lo12:.L_ffffff800a108eb0]
            ldrb w2,[x3],#1
            mov w4,#1
            mov x0,xzr
            blr x8
.L_ffffff8008858b18:

            adrp x19, .L_ffffff800a108de8
            add x19,x19, :lo12:.L_ffffff800a108de8
            ldr x8,[x19,#40]
            mov w0,#20
            blr x8

            ldr x8,[x19]
            mov w0,wzr
            blr x8

            ldr x8,[x19,#40]
            mov w0,#8
            blr x8

            ldr x19,[sp,#16]
            ldp fp,lr,[sp],#32
            ret
.size lcm_suspend, . - lcm_suspend
.align 4
#-----------------------------------
.globl lcm_resume
.type lcm_resume, @function
#-----------------------------------
lcm_resume:

            stp fp,lr,[sp,#-16]!
            mov fp,sp
            adrp x0, .L_ffffff8009255336
            add x0,x0, :lo12:.L_ffffff8009255336
            bl printk

            bl lcm_init

            ldp fp,lr,[sp],#16
            ret
.size lcm_resume, . - lcm_resume
.align 4
#-----------------------------------
.type lcm_init_power, @function
#-----------------------------------
lcm_init_power:

            stp fp,lr,[sp,#-16]!
            mov fp,sp
            adrp x0, .L_ffffff80092552a1
            add x0,x0, :lo12:.L_ffffff80092552a1
            bl printk

            adrp x0, .L_ffffff80099ec468
            add x0,x0, :lo12:.L_ffffff80099ec468
            bl agold_lcm_power_on

            ldp fp,lr,[sp],#16
            ret
.size lcm_init_power, . - lcm_init_power
.align 3
#-----------------------------------
.type lcm_suspend_power, @function
#-----------------------------------
lcm_suspend_power:

            stp fp,lr,[sp,#-16]!
            mov fp,sp
            adrp x0, .L_ffffff80092552f4
            add x0,x0, :lo12:.L_ffffff80092552f4
            bl printk

            adrp x0, .L_ffffff80099ec468
            add x0,x0, :lo12:.L_ffffff80099ec468
            bl agold_lcm_power_off

            ldp fp,lr,[sp],#16
            ret
.size lcm_suspend_power, . - lcm_suspend_power
.align 4
#-----------------------------------
.type lcm_resume_power, @function
#-----------------------------------
lcm_resume_power:

            stp fp,lr,[sp,#-16]!
            mov fp,sp
            adrp x0, .L_ffffff80092552d0
            add x0,x0, :lo12:.L_ffffff80092552d0
            bl printk

            adrp x0, .L_ffffff80099ec468
            add x0,x0, :lo12:.L_ffffff80099ec468
            bl agold_lcm_power_on

            ldp fp,lr,[sp],#16
            ret
.size lcm_resume_power, . - lcm_resume_power
.align 2
#-----------------------------------
.globl agold_lcmldo_enable
.type agold_lcmldo_enable, @function
#-----------------------------------
agold_lcmldo_enable:

            stp fp,lr,[sp,#-32]!
            stp x20,x19,[sp,#16]
            mov fp,sp
            adrp x19, .L_ffffff800a24e368
            ldrb w8,[x19,:lo12:.L_ffffff800a24e368]
            adrp x20, .L_ffffff800a24e370
            tbnz w8,#0,.L_ffffff80089b5d30

            adrp x1, .L_ffffff8009187757
            add x1,x1, :lo12:.L_ffffff8009187757
            mov x0,xzr
            bl regulator_get

            cmn x0,#1,lsl #12
            str x0,[x20,:lo12:.L_ffffff800a24e370]
            b.ls .L_ffffff80089b5d28

            mov x1,x0
            adrp x0, .L_ffffff80092cc623
            add x0,x0, :lo12:.L_ffffff80092cc623
            bl printk

            ldrb w8,[x19,:lo12:.L_ffffff800a24e368]
            cmp w8,#1
            b.eq .L_ffffff80089b5d30

            mov w0,wzr
            b .L_ffffff80089b5d84
.L_ffffff80089b5d28:

            mov w8,#1
            strb w8,[x19,:lo12:.L_ffffff800a24e368]
.L_ffffff80089b5d30:

            ldr x0,[x20,:lo12:.L_ffffff800a24e370]
            mov w1,#47488
            mov w2,#47488
            movk w1,#42,lsl #16
            movk w2,#42,lsl #16
            bl regulator_set_voltage

            mov w19,w0
            tbz w0,#31,.L_ffffff80089b5d60

            adrp x0, .L_ffffff80092c1a0a
            add x0,x0, :lo12:.L_ffffff80092c1a0a
            mov w1,w19
            bl printk
.L_ffffff80089b5d60:

            ldr x0,[x20,:lo12:.L_ffffff800a24e370]
            bl regulator_enable

            mov w20,w0
            tbz w0,#31,.L_ffffff80089b5d80

            adrp x0, .L_ffffff80092c1960
            add x0,x0, :lo12:.L_ffffff80092c1960
            mov w1,w20
            bl printk
.L_ffffff80089b5d80:

            orr w0,w20,w19
.L_ffffff80089b5d84:

            ldp x20,x19,[sp,#16]
            ldp fp,lr,[sp],#32
            ret
.size agold_lcmldo_enable, . - agold_lcmldo_enable
.align 4
#-----------------------------------
.globl agold_lcmldo_disable
.type agold_lcmldo_disable, @function
#-----------------------------------
agold_lcmldo_disable:

            stp fp,lr,[sp,#-32]!
            stp x20,x19,[sp,#16]
            mov fp,sp
            adrp x20, .L_ffffff800a24e368
            ldrb w8,[x20,:lo12:.L_ffffff800a24e368]
            adrp x19, .L_ffffff800a24e370
            tbnz w8,#0,.L_ffffff80089b5df4

            adrp x1, .L_ffffff8009187757
            add x1,x1, :lo12:.L_ffffff8009187757
            mov x0,xzr
            bl regulator_get

            cmn x0,#1,lsl #12
            str x0,[x19,:lo12:.L_ffffff800a24e370]
            b.ls .L_ffffff80089b5dec

            mov x1,x0
            adrp x0, .L_ffffff80092cc623
            add x0,x0, :lo12:.L_ffffff80092cc623
            bl printk

            ldrb w8,[x20,:lo12:.L_ffffff800a24e368]
            cmp w8,#1
            b.eq .L_ffffff80089b5df4

            mov w19,wzr
            b .L_ffffff80089b5e14
.L_ffffff80089b5dec:

            mov w8,#1
            strb w8,[x20,:lo12:.L_ffffff800a24e368]
.L_ffffff80089b5df4:

            ldr x0,[x19,:lo12:.L_ffffff800a24e370]
            bl regulator_disable

            mov w19,w0
            tbz w0,#31,.L_ffffff80089b5e14

            adrp x0, .L_ffffff80092c19de
            add x0,x0, :lo12:.L_ffffff80092c19de
            mov w1,w19
            bl printk
.L_ffffff80089b5e14:

            mov w0,w19
            ldp x20,x19,[sp,#16]
            ldp fp,lr,[sp],#32
            ret
.size agold_lcmldo_disable, . - agold_lcmldo_disable
.align 2
#-----------------------------------
.type agold_display_bias_enable, @function
#-----------------------------------
agold_display_bias_enable:

            stp fp,lr,[sp,#-64]!
            stp x24,x23,[sp,#16]
            stp x22,x21,[sp,#32]
            stp x20,x19,[sp,#48]
            mov fp,sp
            adrp x24, .L_ffffff800a24e390
            ldrb w8,[x24,:lo12:.L_ffffff800a24e390]
            mov w19,w1
            mov w20,w0
            adrp x23, .L_ffffff800a24e380
            adrp x22, .L_ffffff800a24e378
            tbnz w8,#0,.L_ffffff80089b5ec0

            adrp x1, .L_ffffff800917470b
            add x1,x1, :lo12:.L_ffffff800917470b
            mov x0,xzr
            bl regulator_get

            cmn x0,#4095
            str x0,[x23,:lo12:.L_ffffff800a24e380]
            b.lo .L_ffffff80089b5e80

            mov x21,x0
            adrp x0, .L_ffffff80092cc602
            add x0,x0, :lo12:.L_ffffff80092cc602
            b .L_ffffff80089b5ea8
.L_ffffff80089b5e80:

            adrp x1, .L_ffffff800919cbea
            add x1,x1, :lo12:.L_ffffff800919cbea
            mov x0,xzr
            bl regulator_get

            cmn x0,#4095
            str x0,[x22,:lo12:.L_ffffff800a24e378]
            b.lo .L_ffffff80089b5eb8

            mov x21,x0
            adrp x0, .L_ffffff80092cc65d
            add x0,x0, :lo12:.L_ffffff80092cc65d
.L_ffffff80089b5ea8:

            mov w1,w21
            bl printk

            cbnz w21,.L_ffffff80089b5f44

            b .L_ffffff80089b5ec0
.L_ffffff80089b5eb8:

            mov w8,#1
            strb w8,[x24,:lo12:.L_ffffff800a24e390]
.L_ffffff80089b5ec0:

            ldr x0,[x23,:lo12:.L_ffffff800a24e380]
            mov w21,#2304
            mov w24,#34464
            movk w21,#61,lsl #16
            movk w24,#1,lsl #16
            madd w1,w20,w24,w21
            mov w2,w1
            bl regulator_set_voltage

            tbz w0,#31,.L_ffffff80089b5ef0

            adrp x0, .L_ffffff8009266183
            add x0,x0, :lo12:.L_ffffff8009266183
            bl printk
.L_ffffff80089b5ef0:

            ldr x0,[x22,:lo12:.L_ffffff800a24e378]
            madd w1,w19,w24,w21
            mov w2,w1
            bl regulator_set_voltage

            tbz w0,#31,.L_ffffff80089b5f10

            adrp x0, .L_ffffff8009268931
            add x0,x0, :lo12:.L_ffffff8009268931
            bl printk
.L_ffffff80089b5f10:

            ldr x0,[x23,:lo12:.L_ffffff800a24e380]
            bl regulator_enable

            tbz w0,#31,.L_ffffff80089b5f28

            adrp x0, .L_ffffff800926615c
            add x0,x0, :lo12:.L_ffffff800926615c
            bl printk
.L_ffffff80089b5f28:

            ldr x0,[x22,:lo12:.L_ffffff800a24e378]
            bl regulator_enable

            mov w21,w0
            tbz w0,#31,.L_ffffff80089b5f44

            adrp x0, .L_ffffff800926890a
            add x0,x0, :lo12:.L_ffffff800926890a
            bl printk
.L_ffffff80089b5f44:

            mov w0,w21
            ldp x20,x19,[sp,#48]
            ldp x22,x21,[sp,#32]
            ldp x24,x23,[sp,#16]
            ldp fp,lr,[sp],#64
            ret
.size agold_display_bias_enable, . - agold_display_bias_enable
.align 2
#-----------------------------------
.globl agold_display_bias_disable
.type agold_display_bias_disable, @function
#-----------------------------------
agold_display_bias_disable:

            stp fp,lr,[sp,#-48]!
            stp x22,x21,[sp,#16]
            stp x20,x19,[sp,#32]
            mov fp,sp
            adrp x22, .L_ffffff800a24e390
            ldrb w8,[x22,:lo12:.L_ffffff800a24e390]
            adrp x21, .L_ffffff800a24e378
            adrp x20, .L_ffffff800a24e380
            tbnz w8,#0,.L_ffffff80089b5fec

            adrp x1, .L_ffffff800917470b
            add x1,x1, :lo12:.L_ffffff800917470b
            mov x0,xzr
            bl regulator_get

            cmn x0,#4095
            str x0,[x20,:lo12:.L_ffffff800a24e380]
            b.lo .L_ffffff80089b5fac

            mov x19,x0
            adrp x0, .L_ffffff80092cc602
            add x0,x0, :lo12:.L_ffffff80092cc602
            b .L_ffffff80089b5fd4
.L_ffffff80089b5fac:

            adrp x1, .L_ffffff800919cbea
            add x1,x1, :lo12:.L_ffffff800919cbea
            mov x0,xzr
            bl regulator_get

            cmn x0,#4095
            str x0,[x21,:lo12:.L_ffffff800a24e378]
            b.lo .L_ffffff80089b5fe4

            mov x19,x0
            adrp x0, .L_ffffff80092cc65d
            add x0,x0, :lo12:.L_ffffff80092cc65d
.L_ffffff80089b5fd4:

            mov w1,w19
            bl printk

            cbnz w19,.L_ffffff80089b6020

            b .L_ffffff80089b5fec
.L_ffffff80089b5fe4:

            mov w8,#1
            strb w8,[x22,:lo12:.L_ffffff800a24e390]
.L_ffffff80089b5fec:

            ldr x0,[x21,:lo12:.L_ffffff800a24e378]
            bl regulator_disable

            tbz w0,#31,.L_ffffff80089b6004

            adrp x0, .L_ffffff80092688e2
            add x0,x0, :lo12:.L_ffffff80092688e2
            bl printk
.L_ffffff80089b6004:

            ldr x0,[x20,:lo12:.L_ffffff800a24e380]
            bl regulator_disable

            mov w19,w0
            tbz w0,#31,.L_ffffff80089b6020

            adrp x0, .L_ffffff8009266134
            add x0,x0, :lo12:.L_ffffff8009266134
            bl printk
.L_ffffff80089b6020:

            mov w0,w19
            ldp x20,x19,[sp,#32]
            ldp x22,x21,[sp,#16]
            ldp fp,lr,[sp],#48
            ret
.size agold_display_bias_disable, . - agold_display_bias_disable
.align 2
#-----------------------------------
.globl agold_lcm_power_on
.type agold_lcm_power_on, @function
#-----------------------------------
agold_lcm_power_on:

            stp fp,lr,[sp,#-32]!
            str x19,[sp,#16]
            mov fp,sp
            ldr w8,[x0]
            mov x19,x0
            cbnz w8,.L_ffffff80089b6058

            ldr w0,[x19,#8]
            mov w1,#1
            bl agold_gpio_set
.L_ffffff80089b6058:

            ldr w8,[x19,#4]
            cmp w8,#1
            b.eq .L_ffffff80089b6078

            cbnz w8,.L_ffffff80089b607c

            ldr w0,[x19,#12]
            mov w1,#1
            bl agold_gpio_set

            b .L_ffffff80089b607c
.L_ffffff80089b6078:

            bl agold_lcmldo_enable
.L_ffffff80089b607c:

            ldr w0,[x19,#16]
            cmn w0,#1
            b.eq .L_ffffff80089b6098

            ldr w1,[x19,#20]
            cmn w1,#1
            b.eq .L_ffffff80089b6098

            bl agold_display_bias_enable
.L_ffffff80089b6098:

            ldr x19,[sp,#16]
            mov w0,wzr
            ldp fp,lr,[sp],#32
            ret
.size agold_lcm_power_on, . - agold_lcm_power_on
.align 3
#-----------------------------------
.globl agold_lcm_power_off
.type agold_lcm_power_off, @function
#-----------------------------------
agold_lcm_power_off:

            stp fp,lr,[sp,#-48]!
            str x21,[sp,#16]
            stp x20,x19,[sp,#32]
            mov fp,sp
            ldr w8,[x0,#24]
            mov x19,x0
            cbnz w8,.L_ffffff80089b60d8

            ldr w8,[x19]
            cbnz w8,.L_ffffff80089b60d8

            ldr w0,[x19,#8]
            mov w1,wzr
            bl agold_gpio_set
.L_ffffff80089b60d8:

            ldr w8,[x19,#4]
            cmp w8,#1
            b.eq .L_ffffff80089b60f8

            cbnz w8,.L_ffffff80089b6184

            ldr w0,[x19,#12]
            mov w1,wzr
            bl agold_gpio_set

            b .L_ffffff80089b6184
.L_ffffff80089b60f8:

            adrp x20, .L_ffffff800a24e368
            ldrb w8,[x20,:lo12:.L_ffffff800a24e368]
            tbnz w8,#0,.L_ffffff80089b614c

            adrp x1, .L_ffffff8009187757
            add x1,x1, :lo12:.L_ffffff8009187757
            mov x0,xzr
            bl regulator_get

            adrp x8, .L_ffffff800a24e370
            cmn x0,#1,lsl #12
            str x0,[x8,:lo12:.L_ffffff800a24e370]
            b.ls .L_ffffff80089b6144

            mov x1,x0
            adrp x0, .L_ffffff80092cc623
            add x0,x0, :lo12:.L_ffffff80092cc623
            bl printk

            ldrb w8,[x20,:lo12:.L_ffffff800a24e368]
            cmp w8,#1
            b.eq .L_ffffff80089b614c

            b .L_ffffff80089b616c
.L_ffffff80089b6144:

            mov w8,#1
            strb w8,[x20,:lo12:.L_ffffff800a24e368]
.L_ffffff80089b614c:

            adrp x8, .L_ffffff800a24e370
            ldr x0,[x8,:lo12:.L_ffffff800a24e370]
            bl regulator_disable

            tbz w0,#31,.L_ffffff80089b616c

            mov w1,w0
            adrp x0, .L_ffffff80092c19de
            add x0,x0, :lo12:.L_ffffff80092c19de
            bl printk
.L_ffffff80089b616c:

            adrp x20, .L_ffffff800a24e388
            ldrb w8,[x20,:lo12:.L_ffffff800a24e388]
            tbnz w8,#0,.L_ffffff80089b6184

            bl agold_display_bias_disable

            mov w8,#1
            strb w8,[x20,:lo12:.L_ffffff800a24e388]
.L_ffffff80089b6184:

            ldr w8,[x19,#16]
            cmn w8,#1
            b.eq .L_ffffff80089b6224

            ldr w8,[x19,#20]
            cmn w8,#1
            b.eq .L_ffffff80089b6224

            bl agold_display_bias_disable

            adrp x19, .L_ffffff800a24e38c
            ldrb w8,[x19,:lo12:.L_ffffff800a24e38c]
            tbnz w8,#0,.L_ffffff80089b6224

            adrp x21, .L_ffffff800a24e368
            ldrb w8,[x21,:lo12:.L_ffffff800a24e368]
            adrp x20, .L_ffffff800a24e370
            tbnz w8,#0,.L_ffffff80089b6200

            adrp x1, .L_ffffff8009187757
            add x1,x1, :lo12:.L_ffffff8009187757
            mov x0,xzr
            bl regulator_get

            cmn x0,#1,lsl #12
            str x0,[x20,:lo12:.L_ffffff800a24e370]
            b.ls .L_ffffff80089b61f8

            mov x1,x0
            adrp x0, .L_ffffff80092cc623
            add x0,x0, :lo12:.L_ffffff80092cc623
            bl printk

            ldrb w8,[x21,:lo12:.L_ffffff800a24e368]
            cmp w8,#1
            b.eq .L_ffffff80089b6200

            b .L_ffffff80089b621c
.L_ffffff80089b61f8:

            mov w8,#1
            strb w8,[x21,:lo12:.L_ffffff800a24e368]
.L_ffffff80089b6200:

            ldr x0,[x20,:lo12:.L_ffffff800a24e370]
            bl regulator_disable

            tbz w0,#31,.L_ffffff80089b621c

            mov w1,w0
            adrp x0, .L_ffffff80092c19de
            add x0,x0, :lo12:.L_ffffff80092c19de
            bl printk
.L_ffffff80089b621c:

            mov w8,#1
            strb w8,[x19,:lo12:.L_ffffff800a24e38c]
.L_ffffff80089b6224:

            ldp x20,x19,[sp,#32]
            ldr x21,[sp,#16]
            mov w0,wzr
            ldp fp,lr,[sp],#48
            ret
.size agold_lcm_power_off, . - agold_lcm_power_off

#===================================
.section .data
#===================================

.L_ffffff800917470b:
          .ascii "dsv_"
.L_ffffff8009187757:
          .string "mt6370_ldo"
.L_ffffff800919cbea:
          .ascii "dsv_"
.L_ffffff80092551f7:
          .string "[KERNEL/LCM]agold_KERNEL_lcm_init enter\n"
.L_ffffff80092552a1:
          .string "[KERNEL/LCM]agold_KERNEL_lcm_init_power enter\n"
.L_ffffff80092552d0:
          .string "[KERNEL/LCM]lcm_resume_power enter\n"
.L_ffffff80092552f4:
          .string "[KERNEL/LCM]lcm_suspend_power enter\n"
.L_ffffff8009255336:
          .string "[KERNEL/LCM]lcm_resume enter\n"
.L_ffffff800925536c:
          .string "[KERNEL/LCM]lcm_suspend enter\n"
.L_ffffff8009266134:
          .byte 0x1
          .byte 0x33
          .byte 0x64
          .byte 0x69
          .byte 0x73
          .byte 0x61
          .byte 0x62
          .byte 0x6c
          .byte 0x65
          .byte 0x20
          .byte 0x72
          .byte 0x65
          .byte 0x67
          .byte 0x75
          .byte 0x6c
          .byte 0x61
          .byte 0x74
          .byte 0x6f
          .byte 0x72
          .byte 0x20
          .byte 0x64
          .byte 0x69
          .byte 0x73
          .byte 0x70
          .byte 0x5f
          .byte 0x62
          .byte 0x69
          .byte 0x61
          .byte 0x73
          .byte 0x5f
          .byte 0x70
          .byte 0x6f
          .byte 0x73
          .byte 0x20
          .byte 0x66
          .byte 0x61
          .byte 0x69
          .byte 0x6c
          .byte 0xa
          .byte 0x0
.L_ffffff800926615c:
          .byte 0x1
          .byte 0x33
          .byte 0x65
          .byte 0x6e
          .byte 0x61
          .byte 0x62
          .byte 0x6c
          .byte 0x65
          .byte 0x20
          .byte 0x72
          .byte 0x65
          .byte 0x67
          .byte 0x75
          .byte 0x6c
          .byte 0x61
          .byte 0x74
          .byte 0x6f
          .byte 0x72
          .byte 0x20
          .byte 0x64
          .byte 0x69
          .byte 0x73
          .byte 0x70
          .byte 0x5f
          .byte 0x62
          .byte 0x69
          .byte 0x61
          .byte 0x73
          .byte 0x5f
          .byte 0x70
          .byte 0x6f
          .byte 0x73
          .byte 0x20
          .byte 0x66
          .byte 0x61
          .byte 0x69
          .byte 0x6c
          .byte 0xa
          .byte 0x0
.L_ffffff8009266183:
          .byte 0x1
          .byte 0x33
          .byte 0x73
          .byte 0x65
          .byte 0x74
          .byte 0x20
          .byte 0x76
          .byte 0x6f
          .byte 0x6c
          .byte 0x74
          .byte 0x61
          .byte 0x67
          .byte 0x65
          .byte 0x20
          .byte 0x64
          .byte 0x69
          .byte 0x73
          .byte 0x70
          .byte 0x5f
          .byte 0x62
          .byte 0x69
          .byte 0x61
          .byte 0x73
          .byte 0x5f
          .byte 0x70
          .byte 0x6f
          .byte 0x73
          .byte 0x20
          .byte 0x66
          .byte 0x61
          .byte 0x69
          .byte 0x6c
          .byte 0xa
          .byte 0x0
.L_ffffff80092688e2:
          .byte 0x1
          .byte 0x33
          .byte 0x64
          .byte 0x69
          .byte 0x73
          .byte 0x61
          .byte 0x62
          .byte 0x6c
          .byte 0x65
          .byte 0x20
          .byte 0x72
          .byte 0x65
          .byte 0x67
          .byte 0x75
          .byte 0x6c
          .byte 0x61
          .byte 0x74
          .byte 0x6f
          .byte 0x72
          .byte 0x20
          .byte 0x64
          .byte 0x69
          .byte 0x73
          .byte 0x70
          .byte 0x5f
          .byte 0x62
          .byte 0x69
          .byte 0x61
          .byte 0x73
          .byte 0x5f
          .byte 0x6e
          .byte 0x65
          .byte 0x67
          .byte 0x20
          .byte 0x66
          .byte 0x61
          .byte 0x69
          .byte 0x6c
          .byte 0xa
          .byte 0x0
.L_ffffff800926890a:
          .byte 0x1
          .byte 0x33
          .byte 0x65
          .byte 0x6e
          .byte 0x61
          .byte 0x62
          .byte 0x6c
          .byte 0x65
          .byte 0x20
          .byte 0x72
          .byte 0x65
          .byte 0x67
          .byte 0x75
          .byte 0x6c
          .byte 0x61
          .byte 0x74
          .byte 0x6f
          .byte 0x72
          .byte 0x20
          .byte 0x64
          .byte 0x69
          .byte 0x73
          .byte 0x70
          .byte 0x5f
          .byte 0x62
          .byte 0x69
          .byte 0x61
          .byte 0x73
          .byte 0x5f
          .byte 0x6e
          .byte 0x65
          .byte 0x67
          .byte 0x20
          .byte 0x66
          .byte 0x61
          .byte 0x69
          .byte 0x6c
          .byte 0xa
          .byte 0x0
.L_ffffff8009268931:
          .byte 0x1
          .byte 0x33
          .byte 0x73
          .byte 0x65
          .byte 0x74
          .byte 0x20
          .byte 0x76
          .byte 0x6f
          .byte 0x6c
          .byte 0x74
          .byte 0x61
          .byte 0x67
          .byte 0x65
          .byte 0x20
          .byte 0x64
          .byte 0x69
          .byte 0x73
          .byte 0x70
          .byte 0x5f
          .byte 0x62
          .byte 0x69
          .byte 0x61
          .byte 0x73
          .byte 0x5f
          .byte 0x6e
          .byte 0x65
          .byte 0x67
          .byte 0x20
          .byte 0x66
          .byte 0x61
          .byte 0x69
          .byte 0x6c
          .byte 0xa
          .byte 0x0
.L_ffffff80092c18fd:
          .byte 0x1
          .byte 0x36
          .byte 0x64
          .byte 0x69
          .byte 0x73
          .byte 0x61
          .byte 0x62
          .byte 0x6c
          .byte 0x65
          .byte 0x20
          .byte 0x72
          .byte 0x65
          .byte 0x67
          .byte 0x75
          .byte 0x6c
          .byte 0x61
          .byte 0x74
          .byte 0x6f
          .byte 0x72
          .byte 0x20
          .byte 0x64
          .byte 0x69
          .byte 0x73
          .byte 0x70
          .byte 0x5f
          .byte 0x62
          .byte 0x69
          .byte 0x61
          .byte 0x73
          .byte 0x5f
          .byte 0x70
          .byte 0x6f
          .byte 0x73
          .byte 0x20
          .byte 0x66
          .byte 0x61
          .byte 0x69
          .byte 0x6c
          .byte 0x2c
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
.L_ffffff80092c192f:
          .byte 0x1
          .byte 0x36
          .byte 0x65
          .byte 0x6e
          .byte 0x61
          .byte 0x62
          .byte 0x6c
          .byte 0x65
          .byte 0x20
          .byte 0x72
          .byte 0x65
          .byte 0x67
          .byte 0x75
          .byte 0x6c
          .byte 0x61
          .byte 0x74
          .byte 0x6f
          .byte 0x72
          .byte 0x20
          .byte 0x64
          .byte 0x69
          .byte 0x73
          .byte 0x70
          .byte 0x5f
          .byte 0x62
          .byte 0x69
          .byte 0x61
          .byte 0x73
          .byte 0x5f
          .byte 0x70
          .byte 0x6f
          .byte 0x73
          .byte 0x20
          .byte 0x66
          .byte 0x61
          .byte 0x69
          .byte 0x6c
          .byte 0x2c
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
.L_ffffff80092c1960:
          .byte 0x1
          .byte 0x33
          .byte 0x65
          .byte 0x6e
          .byte 0x61
          .byte 0x62
          .byte 0x6c
          .byte 0x65
          .byte 0x20
          .byte 0x72
          .byte 0x65
          .byte 0x67
          .byte 0x75
          .byte 0x6c
          .byte 0x61
          .byte 0x74
          .byte 0x6f
          .byte 0x72
          .byte 0x20
          .byte 0x64
          .byte 0x69
          .byte 0x73
          .byte 0x70
          .byte 0x5f
          .byte 0x62
          .byte 0x69
          .byte 0x61
          .byte 0x73
          .byte 0x5f
          .byte 0x70
          .byte 0x6f
          .byte 0x73
          .byte 0x20
          .byte 0x66
          .byte 0x61
          .byte 0x69
          .byte 0x6c
          .byte 0x2c
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
.L_ffffff80092c1991:
          .byte 0x1
          .byte 0x36
          .byte 0x73
          .byte 0x65
          .byte 0x74
          .byte 0x20
          .byte 0x76
          .byte 0x6f
          .byte 0x6c
          .byte 0x74
          .byte 0x61
          .byte 0x67
          .byte 0x65
          .byte 0x20
          .byte 0x64
          .byte 0x69
          .byte 0x73
          .byte 0x70
          .byte 0x5f
          .byte 0x62
          .byte 0x69
          .byte 0x61
          .byte 0x73
          .byte 0x5f
          .byte 0x70
          .byte 0x6f
          .byte 0x73
          .byte 0x20
          .byte 0x66
          .byte 0x61
          .byte 0x69
          .byte 0x6c
          .byte 0x2c
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
.L_ffffff80092c19de:
          .byte 0x1
          .byte 0x33
          .byte 0x64
          .byte 0x69
          .byte 0x73
          .byte 0x61
          .byte 0x62
          .byte 0x6c
          .byte 0x65
          .byte 0x20
          .byte 0x72
          .byte 0x65
          .byte 0x67
          .byte 0x75
          .byte 0x6c
          .byte 0x61
          .byte 0x74
          .byte 0x6f
          .byte 0x72
          .byte 0x20
          .byte 0x6c
          .byte 0x63
          .byte 0x6d
          .byte 0x5f
          .byte 0x6c
          .byte 0x64
          .byte 0x6f
          .byte 0x20
          .byte 0x66
          .byte 0x61
          .byte 0x69
          .byte 0x6c
          .byte 0x2c
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
.L_ffffff80092c1a0a:
          .byte 0x1
          .byte 0x33
          .byte 0x73
          .byte 0x65
          .byte 0x74
          .byte 0x20
          .byte 0x76
          .byte 0x6f
          .byte 0x6c
          .byte 0x74
          .byte 0x61
          .byte 0x67
          .byte 0x65
          .byte 0x20
          .byte 0x6c
          .byte 0x63
          .byte 0x6d
          .byte 0x5f
          .byte 0x6c
          .byte 0x64
          .byte 0x6f
          .byte 0x20
          .byte 0x66
          .byte 0x61
          .byte 0x69
          .byte 0x6c
          .byte 0x2c
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
.L_ffffff80092c1a4f:
          .byte 0x1
          .byte 0x36
          .byte 0x64
          .byte 0x69
          .byte 0x73
          .byte 0x61
          .byte 0x62
          .byte 0x6c
          .byte 0x65
          .byte 0x20
          .byte 0x72
          .byte 0x65
          .byte 0x67
          .byte 0x75
          .byte 0x6c
          .byte 0x61
          .byte 0x74
          .byte 0x6f
          .byte 0x72
          .byte 0x20
          .byte 0x64
          .byte 0x69
          .byte 0x73
          .byte 0x70
          .byte 0x5f
          .byte 0x62
          .byte 0x69
          .byte 0x61
          .byte 0x73
          .byte 0x5f
          .byte 0x6e
          .byte 0x65
          .byte 0x67
          .byte 0x20
          .byte 0x66
          .byte 0x61
          .byte 0x69
          .byte 0x6c
          .byte 0x2c
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
.L_ffffff80092c1a81:
          .byte 0x1
          .byte 0x36
          .byte 0x65
          .byte 0x6e
          .byte 0x61
          .byte 0x62
          .byte 0x6c
          .byte 0x65
          .byte 0x20
          .byte 0x72
          .byte 0x65
          .byte 0x67
          .byte 0x75
          .byte 0x6c
          .byte 0x61
          .byte 0x74
          .byte 0x6f
          .byte 0x72
          .byte 0x20
          .byte 0x64
          .byte 0x69
          .byte 0x73
          .byte 0x70
          .byte 0x5f
          .byte 0x62
          .byte 0x69
          .byte 0x61
          .byte 0x73
          .byte 0x5f
          .byte 0x6e
          .byte 0x65
          .byte 0x67
          .byte 0x20
          .byte 0x66
          .byte 0x61
          .byte 0x69
          .byte 0x6c
          .byte 0x2c
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
.L_ffffff80092c1ab2:
          .byte 0x1
          .byte 0x36
          .byte 0x73
          .byte 0x65
          .byte 0x74
          .byte 0x20
          .byte 0x76
          .byte 0x6f
          .byte 0x6c
          .byte 0x74
          .byte 0x61
          .byte 0x67
          .byte 0x65
          .byte 0x20
          .byte 0x64
          .byte 0x69
          .byte 0x73
          .byte 0x70
          .byte 0x5f
          .byte 0x62
          .byte 0x69
          .byte 0x61
          .byte 0x73
          .byte 0x5f
          .byte 0x6e
          .byte 0x65
          .byte 0x67
          .byte 0x20
          .byte 0x66
          .byte 0x61
          .byte 0x69
          .byte 0x6c
          .byte 0x2c
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
.L_ffffff80092cc5e3:
          .byte 0x1
          .byte 0x36
          .byte 0x67
          .byte 0x65
          .byte 0x74
          .byte 0x20
          .byte 0x64
          .byte 0x73
          .byte 0x76
          .byte 0x5f
          .byte 0x70
          .byte 0x6f
          .byte 0x73
          .byte 0x20
          .byte 0x66
          .byte 0x61
          .byte 0x69
          .byte 0x6c
          .byte 0x2c
          .byte 0x20
          .byte 0x65
          .byte 0x72
          .byte 0x72
          .byte 0x6f
          .byte 0x72
          .byte 0x3a
          .byte 0x20
          .byte 0x25
          .byte 0x64
          .byte 0xa
          .byte 0x0
.L_ffffff80092cc602:
          .byte 0x1
          .byte 0x33
          .byte 0x64
          .byte 0x69
          .byte 0x73
          .byte 0x70
          .byte 0x5f
          .byte 0x62
          .byte 0x69
          .byte 0x61
          .byte 0x73
          .byte 0x5f
          .byte 0x70
          .byte 0x6f
          .byte 0x73
          .byte 0x20
          .byte 0x66
          .byte 0x61
          .byte 0x69
          .byte 0x6c
          .byte 0x2c
          .byte 0x20
          .byte 0x65
          .byte 0x72
          .byte 0x72
          .byte 0x6f
          .byte 0x72
          .byte 0x3a
          .byte 0x20
          .byte 0x25
          .byte 0x64
          .byte 0xa
          .byte 0x0
.L_ffffff80092cc623:
          .byte 0x1
          .byte 0x33
          .byte 0x6c
          .byte 0x63
          .byte 0x6d
          .byte 0x5f
          .byte 0x6c
          .byte 0x64
          .byte 0x6f
          .byte 0x20
          .byte 0x66
          .byte 0x61
          .byte 0x69
          .byte 0x6c
          .byte 0x2c
          .byte 0x20
          .byte 0x65
          .byte 0x72
          .byte 0x72
          .byte 0x6f
          .byte 0x72
          .byte 0x3a
          .byte 0x20
          .byte 0x25
          .byte 0x64
          .byte 0xa
          .byte 0x0
.L_ffffff80092cc63e:
          .byte 0x1
          .byte 0x36
          .byte 0x67
          .byte 0x65
          .byte 0x74
          .byte 0x20
          .byte 0x64
          .byte 0x73
          .byte 0x76
          .byte 0x5f
          .byte 0x6e
          .byte 0x65
          .byte 0x67
          .byte 0x20
          .byte 0x66
          .byte 0x61
          .byte 0x69
          .byte 0x6c
          .byte 0x2c
          .byte 0x20
          .byte 0x65
          .byte 0x72
          .byte 0x72
          .byte 0x6f
          .byte 0x72
          .byte 0x3a
          .byte 0x20
          .byte 0x25
          .byte 0x64
          .byte 0xa
          .byte 0x0
.L_ffffff80092cc65d:
          .byte 0x1
          .byte 0x33
          .byte 0x64
          .byte 0x69
          .byte 0x73
          .byte 0x70
          .byte 0x5f
          .byte 0x62
          .byte 0x69
          .byte 0x61
          .byte 0x73
          .byte 0x5f
          .byte 0x6e
          .byte 0x65
          .byte 0x67
          .byte 0x20
          .byte 0x66
          .byte 0x61
          .byte 0x69
          .byte 0x6c
          .byte 0x2c
          .byte 0x20
          .byte 0x65
          .byte 0x72
          .byte 0x72
          .byte 0x6f
          .byte 0x72
          .byte 0x3a
          .byte 0x20
          .byte 0x25
          .byte 0x64
          .byte 0xa
          .byte 0x0
.align 8
.L_ffffff80099ec1e0:
          .byte 0x11
          .byte 0x0
          .byte 0x0
          .byte 0x0
.L_ffffff80099ec1e4:
          .zero 68
.L_ffffff80099ec228:
          .byte 0xfe
          .byte 0xf
          .byte 0x0
          .byte 0x0
.L_ffffff80099ec22c:
          .byte 0x78
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
.L_ffffff80099ec270:
          .byte 0x29
          .byte 0x0
          .byte 0x0
          .byte 0x0
.L_ffffff80099ec274:
          .zero 68
.L_ffffff80099ec2b8:
          .byte 0xfe
          .byte 0xf
          .byte 0x0
          .byte 0x0
.L_ffffff80099ec2bc:
          .byte 0x78
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
.L_ffffff80099ec300:
          .byte 0x28
          .byte 0x0
          .byte 0x0
          .byte 0x0
.L_ffffff80099ec304:
          .zero 68
.L_ffffff80099ec348:
          .byte 0xfe
          .byte 0xf
          .byte 0x0
          .byte 0x0
.L_ffffff80099ec34c:
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
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
.L_ffffff80099ec390:
          .byte 0x10
          .byte 0x0
          .byte 0x0
          .byte 0x0
.L_ffffff80099ec394:
          .zero 68
.L_ffffff80099ec3d8:
          .byte 0xfe
          .byte 0xf
          .byte 0x0
          .byte 0x0
.L_ffffff80099ec3dc:
          .byte 0x78
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
.L_ffffff80099ec420:
          .byte 0xff
          .byte 0xf
          .byte 0x0
          .byte 0x0
.L_ffffff80099ec424:
          .zero 68
.L_ffffff80099ec468:
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0xb1
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0xb2
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0xa
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0xa
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
          .byte 0x0
#===================================
# end section .kernel
#===================================

#===================================
.section .bss
#===================================

.L_ffffff800a108dd0:
          .zero 8
.L_ffffff800a108dd8:
          .zero 8
.L_ffffff800a108de0:
          .zero 8
.L_ffffff800a108de8:
          .zero 40
.L_ffffff800a108e10:
          .zero 160
.L_ffffff800a108eb0:
          .zero 48
.L_ffffff800a24e368:
          .zero 8
.L_ffffff800a24e370:
          .zero 8
.L_ffffff800a24e378:
          .zero 8
.L_ffffff800a24e380:
          .zero 8
.L_ffffff800a24e388:
          .zero 4
.L_ffffff800a24e38c:
          .zero 4
.L_ffffff800a24e390:
          .zero 8
#===================================
# end section .bss
#===================================
