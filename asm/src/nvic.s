/**
 * @file nvic.s
 * @author Vladyslav Aviedov <vladaviedov at protonmail dot com>
 * @version 0.1
 * @date 2024
 * @license GPLv3.0
 * @brief Internal CPU interrupt configuration.
 */
.syntax unified
.cpu cortex-m0
.thumb

/**
 * Note: NVIC information comes from the programming manual!!
 */

/**
 * Base subsystem memory addresses
 */

// Nested vectored interrupt controller
.equ nvic, 0xe000e100
// NVIC registers
.equ nvic_iser_reg, 0x000
.equ nvic_icpr_reg, 0x180
.equ nvic_ipr0_reg, 0x300

.global nvic_enable_int
.global nvic_set_priority

.section .text

/**
 * Enable interrupt
 *	r0: interrupt number
 */
nvic_enable_int:
	push {r0-r3}
	// Compute value
	movs r1, #1
	lsls r1, r1, r0
	// Set bit
	ldr r2, =(nvic + nvic_iser_reg)
	ldr r3, [r2]
	orrs r3, r3, r1
	str r3, [r2]
	pop {r0-r3}
	bx lr

/**
 * Set interrupt priority
 *	r0: interrupt number
 *	r1: priority value
 */
nvic_set_priority:
	push {lr}
	push {r0-r5}
	// Calc shifts
	push {r1}
	bl priority_shifts
	pop {r2}
	// Find correct register
	ldr r3, =(nvic + nvic_ipr0_reg)
	adds r3, r3, r0
	// Compute mask & value
	movs r4, #0xff
	lsls r4, r4, r1
	mvns r4, r4
	lsls r2, r2, r1
	// Write
	ldr r5, [r3]
	ands r5, r5, r4
	orrs r5, r5, r2
	str r5, [r3]
	pop {r0-r5}
	pop {pc}

/**
 * Calculate priority register offset and shift
 *	r0: value
 * Returns:
 *	r0: register shift
 *	r1: bits shift
 */
priority_shifts:
	// Bit shift value
	movs r1, r0
	movs r2, #0b11
	ands r1, r1, r2
	movs r2, #8
	muls r1, r1, r2
	// Register shift value
	lsrs r0, r0, #2
	lsls r0, r0, #2
	bx lr

.end
