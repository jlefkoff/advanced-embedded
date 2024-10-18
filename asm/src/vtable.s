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
.org 0x00
	.word _stack_end
	.word isr_reset

/**
 * Reset handler
 * This is executed first after boot or after reset
 */
.thumb_func
isr_reset:
	ldr r0, =_stack_end
	mov sp, r0
	b main
