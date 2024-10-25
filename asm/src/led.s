/**
 * @file led.s
 * @author Vladyslav Aviedov <vladaviedov at protonmail dot com>
 * @version 0.1
 * @date 2024
 * @license GPLv3.0
 * @brief LED output driver.
 */
.syntax unified
.cpu cortex-m0
.thumb

.global led_setup
.global led_update

.section .text

/**
 * Setup the LEDs for output
 */
led_setup:
	push {lr}
	push {r0-r1}
	// Set pins to output
	movs r1, #0b01
	movs r0, #0
	bl gpioa_set_mode
	movs r0, #1
	bl gpioa_set_mode
	movs r0, #2
	bl gpioa_set_mode
	movs r0, #3
	bl gpioa_set_mode
	pop {r0-r1}
	pop {pc}

/**
 * Update current LED status based on r5
 */
led_update:
	push {lr}
	push {r0-r3}
	// Current port number
	movs r0, #0
	// Copy counter value into r2
	movs r3, r6
update_loop:
	// Move 1 into r3
	movs r1, #1
	// r1 = r3 & 1
	ands r1, r1, r3
	// Set LED
	bl set_led
	// Increment port
	adds r0, r0, #1
	// Right shift register
	lsrs r3, r3, #1
	// End of loop check
	cmp r0, #4
	bne update_loop
	pop {r0-r3}
	pop {pc}

/**
 * Wrapper for active-low LED
 * 	r0: port
 *	r1: value
 */
set_led:
	push {lr}
	// HINT: push {r???}
	// TODO: add logic here to fix the clock
	bl gpioa_set_bit
	// HINT: pop {r???}
	pop {pc}

.end
