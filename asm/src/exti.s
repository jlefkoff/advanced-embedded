/**
 * @file exti.s
 * @author Vladyslav Aviedov <vladaviedov at protonmail dot com>
 * @version 0.1
 * @date 2024
 * @license GPLv3.0
 * @brief External interrupt configuration.
 */
.syntax unified
.cpu cortex-m0
.thumb

/**
 * Base subsystem memory addresses
 */

// RCC - Reset & Clock Controller
.equ rcc, 0x40021000
// System configuration
.equ syscfg, 0x40010000
// External interrupt configuration
.equ exti, 0x40010400

/**
 * RCC Registers
 */

// APB2 enable register
.equ rcc_apb2en_reg, 0x18
// APB2 values
.equ rcc_apb2en_syscfg, 1 << 0

/**
 * System configuration registers
 */

// External interrupt configuration register 1
.equ syscfg_exticr1_reg, 0x08
// EXTI CR1 values
.equ syscfg_exticr1_exti0_mask, 0xfffffff0
.equ syscfg_exticr1_exti0_gpioa, 0x0

/**
 * External interrupt registers
 */

// Interrupt mask register
.equ exti_imr_reg, 0x00

// Rising-edge trigger selection register
.equ exti_rtsr_reg, 0x08

// Falling-edge trigger selection register
.equ exti_ftsr_reg, 0x0c

// Pending interrupt register
.equ exti_pr_reg, 0x14

// EXTI0 value for previous four registers
.equ exti_exti0, 1

.global exti_enable
.global exti_link_pa0
.global exti_clear_int0

.section .text

/**
 * Enable external interrupt subsystem
 */
exti_enable:
	push {r0-r2}
	// Enable Clock for SYSCFG
	ldr r0, =(rcc + rcc_apb2en_reg)
	ldr r1, =rcc_apb2en_syscfg
	ldr r2, [r0]
	orrs r2, r2, r1
	str r2, [r0]
	pop {r0-r2}
	bx lr

/**
 * Links GPIO port A0 to EXTI 0
 */
exti_link_pa0:
	push {lr}
	push {r0-r2}
	// Set A pin for EXTI0
	ldr r0, =(syscfg + syscfg_exticr1_reg)	
	ldr r1, =syscfg_exticr1_exti0_mask
	ldr r2, [r0]
	ands r2, r2, r1
	ldr r1, =syscfg_exticr1_exti0_gpioa
	orrs r2, r2, r1
	str r2, [r0]
	// Set GPIO mode and pullups
	movs r0, #0
	movs r1, #0b00
	bl gpioa_set_mode
	movs r0, #0
	movs r1, #0b00
	bl gpioa_set_pupd
	// Enable mask
	ldr r0, =(exti + exti_imr_reg)
	ldr r1, =exti_exti0
	ldr r2, [r0]
	orrs r2, r2, r1
	str r2, [r0]
	// Enable falling edge
	ldr r0, =(exti + exti_ftsr_reg)
	ldr r2, [r0]
	orrs r2, r2, r1
	str r2, [r0]
	// Disable rising edge
	mvns r1, r1
	ldr r0, =(exti + exti_rtsr_reg)
	ldr r2, [r0]
	ands r2, r2, r1
	str r2, [r0]
	// Enable int & set priority
	movs r0, #5
	bl nvic_enable_int
	movs r1, #0b00
	bl nvic_set_priority
	pop {r0-r2}
	pop {pc}

/**
 * Clear interrupt state on EXTI0
 */
exti_clear_int0:
	push {r0-r2}
	ldr r0, =(exti + exti_pr_reg)
	ldr r1, =exti_exti0
	ldr r2, [r0]
	str r1, [r0]
	ldr r2, [r0]
	pop {r0-r2}
	bx lr

.end
