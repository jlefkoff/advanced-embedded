/**
 * @file main.s
 * @author Vladyslav Aviedov <vladaviedov at protonmail dot com>
 * @version 0.1
 * @date 2024
 * @license GPLv3.0
 */
.syntax unified
.cpu cortex-m0
.thumb

.global main

.section .text

main:
	// Light on-board LED
	bl gpio_enable
	// Set GPIOB port 3 to out
	movs r0, #3
	movs r1, #0b01
	bl gpiob_set_mode
	// Set GPIOB port 3 to high
	movs r0, #3
	movs r1, #1
	bl gpiob_set_bit
loop:
	nop
	b loop

.end
