/**
 * @file vtable.s
 * @author Vladyslav Aviedov <vladaviedov at protonmail dot com>
 * @version 0.1
 * @date 2024
 * @license GPLv3.0
 * @brief Vector table and ISR handlers.
 */
.syntax unified
.cpu cortex-m0
.thumb

.global vtable

.section .text

/**
 * Vector table:
 * 0x00 - Stack end address
 * 0x04 - Reset ISR
 */
vtable:
// Stack end pointer
.org 0x00
	.word _stack_end
// Reset ISR handler
.org 0x04
	.word isr_reset
// Timer ISR handler
.org 0x7c
	.word isr_timer
// End of the table
.org 0xc0

/**
 * Reset handler
 * This is executed first after boot or after reset
 */
.thumb_func
isr_reset:
	ldr r0, =_stack_end
	mov sp, r0
	b main

/**
 * Timer interrupt handler
 * This is executed every time the internal timer reaches the condition set by us
 */
.thumb_func
isr_timer:
	push {lr}
	// Reset timer
	bl timer_clear_int

	// CHALLENGE: 3
	// SOLUTION START
	
	// Call subroutine with argument of 0
	movs r0, #0
	bl gpioa_get_bit

	// Check return value
	cmp r0, #1
	// This instruction only runs if the above statement is true
	beq timer_inc

	// The commented lines below are not necessary
	// Only added to make the logic more readable

// timer_dec:
	subs r6, r6, #1
	bl timer_end
timer_inc:
	adds r6, r6, #1
	// bl timer_end

timer_end:
	// SOLUTION END

	// Update I/O
	bl led_update
	pop {pc}

.end
