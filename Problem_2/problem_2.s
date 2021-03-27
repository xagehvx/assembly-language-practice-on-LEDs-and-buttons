/*
 * problem_2.s
 *
 * Mehmet Akif Gümüş
 *
 */


.syntax unified
.cpu cortex-m0plus
.fpu softvfp
.thumb


/* make linker see this */
.global Reset_Handler

/* get these from linker script */
.word _sdata
.word _edata
.word _sbss
.word _ebss


/* define peripheral addresses from RM0444 page 57, Tables 3-4 */
.equ RCC_BASE,         (0x40021000)          // RCC base address
.equ RCC_IOPENR,       (RCC_BASE   + (0x34)) // RCC IOPENR register offset

.equ GPIOA_BASE,       (0x50000000)          // GPIOA base address
.equ GPIOA_MODER,      (GPIOA_BASE + (0x00)) // GPIOA MODER register offset
.equ GPIOA_ODR,        (GPIOA_BASE + (0x14)) // GPIOA ODR output offset
.equ GPIOA_IDR,        (GPIOA_BASE + (0x10)) // GPIOA ODR input offset

/* vector table, +1 thumb mode */
.section .vectors
vector_table:
	.word _estack             /*     Stack pointer */
	.word Reset_Handler +1    /*     Reset handler */
	.word Default_Handler +1  /*       NMI handler */
	.word Default_Handler +1  /* HardFault handler */
	/* add rest of them here if needed */


/* reset handler */
.section .text
Reset_Handler:
	/* set stack pointer */
	ldr r0, =_estack
	mov sp, r0

	/* initialize data and bss 
	 * not necessary for rom only code 
	 * */
	bl init_data
	/* call main */
	bl main
	/* trap if returned */
	b .


/* initialize data and bss sections */
.section .text
init_data:

	/* copy rom to ram */
	ldr r0, =_sdata
	ldr r1, =_edata
	ldr r2, =_sidata
	movs r3, #0
	b LoopCopyDataInit

	CopyDataInit:
		ldr r4, [r2, r3]
		str r4, [r0, r3]
		adds r3, r3, #4

	LoopCopyDataInit:
		adds r4, r0, r3
		cmp r4, r1
		bcc CopyDataInit

	/* zero bss */
	ldr r2, =_sbss
	ldr r4, =_ebss
	movs r3, #0
	b LoopFillZerobss

	FillZerobss:
		str  r3, [r2]
		adds r2, r2, #4

	LoopFillZerobss:
		cmp r2, r4
		bcc FillZerobss

	bx lr


/* default handler */
.section .text
Default_Handler:
	b Default_Handler


/* main function */
.section .text
main:
	/* sent clock for enable GPIOC, bit2 on IOPENR */

	ldr r6, =RCC_IOPENR
	ldr r5, [r6]
	movs r4, 0x1
	orrs r5, r5, r4
	str r5, [r6]

	/* setup PA7 as output pin for led_one 01 for bits 14-15 in MODER */
	ldr r6, =GPIOA_MODER
	ldr r5, [r6]
	/* cannot do with movs, so use pc relative */
	movs r4,0x3 //0011
	lsls r4,r4,#14
	bics r5,r5,r4
	movs r4, 0x1 //0001
	lsls r4, r4, #14
	orrs r5, r5, r4
	str r5, [r6]

	/* setup PA4 as input pin for button 00 for bits 8-9 in MODER */
	ldr r3, =GPIOA_MODER
	ldr r5, [r3]
	/* cannot do with movs, so use pc relative */
	movs r4,0x3
	lsls r4,r4,#8
	bics r5,r5,r4
	str r5, [r3]
button_control:

	/* press button connected to PA4 in IDR*/
	ldr r6, =GPIOA_IDR
	ldr r5, [r6]
	lsrs r5, r5, #4
	movs r4, #0x1 //0001
	ands r5, r5, r4


	cmp r5, #0x1
	beq led_on
	bne led_off

led_on:

	/* turn on led connected to PA7 in ODR */
	ldr r6, =GPIOA_ODR
	ldr r5, [r6]
	movs r4, 0x80  //100 0000
	orrs r5, r5, r4
	str r5, [r6]
	b button_control
led_off:
/* turn off led connected to PA7 in ODR */
	ldr r6, =GPIOA_ODR
	ldr r5, [r6]
	movs r4, 0x80
	bics r5, r5, r4
	str r5, [r6]
	b button_control

	/* for(;;); */


	/* this should never get executed */
	nop
