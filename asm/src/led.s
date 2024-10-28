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

// LED pin map
.equ led0, 1
.equ led1, 2
.equ led2, 3
.equ led3, 4

.global led_setup
.global led_update

.section .text

/**
 * Setup the LEDs for output
 */
led_setup:
	push {lr}
	push {r0-r1}
	// Set all LEDs to ouput
	movs r1, #0b01
	ldr r0, =led0
	bl gpioa_set_mode
	ldr r0, =led1
	bl gpioa_set_mode
	ldr r0, =led2
	bl gpioa_set_mode
	ldr r0, =led3
	bl gpioa_set_mode
	pop {r0-r1}
	pop {pc}

/**
 * Update current LED status based on r5
 */
led_update:
	push {lr}
	push {r0-r3}
	// Start from first led
	ldr r0, =led0
	// Copy counter value into r2
	movs r3, r6
update_loop:
	// r1 = r3 & 1
	movs r1, #1
	ands r1, r1, r3
	// Set LED
	bl set_led
	// Increment port
	adds r0, r0, #1
	// Right shift register
	lsrs r3, r3, #1
	// End of loop check
	cmp r0, led3
	ble update_loop
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
