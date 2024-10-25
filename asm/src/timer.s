/**
 * @file timer.s
 * @author Vladyslav Aviedov <vladaviedov at protonmail dot com>
 * @version 0.1
 * @date 2024
 * @license GPLv3.0
 * @brief Timer configuration.
 */
.syntax unified
.cpu cortex-m0
.thumb

/**
 * Base subsystem memory addresses
 */

// RCC - Reset & Clock Controller
.equ rcc, 0x40021000
// Timer 2
.equ tim2, 0x40000000

/**
 * RCC Registers
 */

// APB1 enable register
.equ rcc_apb1en_reg, 0x1c
// APB1 register values
.equ rcc_apb1en_tim2, 1 << 0

/**
 * Timer 2 Registers
 */

// Control register 1
.equ tim2_cr1_reg, 0x00
// CR1 values
.equ tim2_cr1_en, 1 << 0

// DMA & Interrupt register
.equ tim2_dier_reg, 0x0c
// DMA & Interrupt values
.equ tim2_dier_cc1ie, 1 << 1

// Status register
.equ tim2_sr_reg, 0x10
// Status values
.equ tim2_sr_cc1if, 1 << 1

// Auto-reload register
.equ tim2_arr_reg, 0x2c

// Capture / compare value register
.equ tim2_ccr1_reg, 0x34

// NVIC interrupt number
.equ nvic_int_value, 15
// 1 Second Timer Preset
.equ preload_value, 0x007a1200

.global timer_setup
.global timer_start
.global timer_clear_int

.section .text

/**
 * Setup timer 2
 */
timer_setup:
	push {lr}
	push {r0-r2}
	// Clock enable
	ldr r0, =(rcc + rcc_apb1en_reg)
	ldr r1, =rcc_apb1en_tim2
	ldr r2, [r0]
	orrs r2, r2, r1
	str r2, [r0]
	// Enable CC1 interrupt
	ldr r0, =(tim2 + tim2_dier_reg)
	ldr r1, =tim2_dier_cc1ie
	ldr r2, [r0]
	orrs r2, r2, r1
	str r2, [r0]
	// Set preload
	ldr r0, =(tim2 + tim2_ccr1_reg)
	ldr r1, =preload_value
	str r1, [r0]
	ldr r0, =(tim2 + tim2_arr_reg)
	str r1, [r0]
	// Modify NVIC
	ldr r0, =nvic_int_value
	bl nvic_enable_int
	movs r1, #0
	bl nvic_set_priority
	pop {r0-r2}
	pop {pc}

/**
 * Start timer 2
 */
timer_start:
	push {r0-r2}
	ldr r0, =(tim2 + tim2_cr1_reg)
	ldr r1, =tim2_cr1_en
	ldr r2, [r0]
	orrs r2, r2, r1
	str r2, [r0]
	pop {r0-r2}
	bx lr

/**
 * Clear interrupt on timer 2
 */
timer_clear_int:
	push {r0-r2}
	ldr r0, =(tim2 + tim2_sr_reg)
	ldr r1, =tim2_sr_cc1if
	mvns r1, r1
	ldr r2, [r0]
	ands r2, r2, r1
	str r2, [r0]
	pop {r0-r2}
	bx lr

.end
