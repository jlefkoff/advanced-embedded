/**
 * @file gpio.s
 * @author Vladyslav Aviedov <vladaviedov at protonmail dot com>
 * @version 0.1
 * @date 2024
 * @license GPLv3.0
 * @brief GPIO control driver.
 */
.syntax unified
.cpu cortex-m0
.thumb

/**
 * Base subsystem memory addresses
 */

// RCC - Reset & Clock Controller
.equ rcc, 0x40021000
// GPIO Port A
.equ gpioa, 0x48000000
// GPIO Port B
.equ gpiob, 0x48000400

/**
 * RCC Registers
 */

// AHB enable register
.equ rcc_ahben_reg, 0x14
// AHB register values
.equ rcc_ahben_gpioa, 0b1 << 17
.equ rcc_ahben_gpiob, 0b1 << 18

/**
 * GPIO Port Registers
 */

// Mode configuration
.equ gpio_mode_reg, 0x00

// Pull-up / pull-down configuration
.equ gpio_pupd_reg, 0x0c

// Data register
.equ gpio_data_reg, 0x14

.global gpio_enable
.global gpioa_set_mode
.global gpiob_set_mode
.global gpioa_set_bit
.global gpiob_set_bit
.global gpioa_set_pupd
.global gpiob_set_pupd

.section .text

/**
 * Enable Clock for GPIOs (A + B)
 */
gpio_enable:
	push {r0-r2}
	ldr r0, =(rcc + rcc_ahben_reg)
	ldr r1, [r0]
	ldr r2, =rcc_ahben_gpioa
	orrs r1, r2
	ldr r2, =rcc_ahben_gpiob
	orrs r1, r2
	str r1, [r0]
	pop {r0-r2}
	bx lr

/**	
 * Set mode for a GPIOA pin
 * 	r0: port
 *	r1: value
 */
gpioa_set_mode:
	push {lr}
	push {r0-r4}
	ldr r2, =(gpioa + gpio_mode_reg)
	bl gpio_set_mode
	pop {r0-r4}
	pop {pc}

/**
 * Set mode for a GPIOA pin
 *	r0: port
 *	r1: value
 */
gpiob_set_mode:
	push {lr}
	push {r0-r4}
	ldr r2, =(gpiob + gpio_mode_reg)
	bl gpio_set_mode
	pop {r0-r4}
	pop {pc}

/**
 * Set bit for a GPIOA pin
 *	r0: port
 *	r1: value
 */
gpioa_set_bit:
	push {lr}
	push {r0-r4}
	ldr r2, =(gpioa + gpio_data_reg)
	bl gpio_set_bit
	pop {r0-r4}
	pop {pc}

/**
 * Set bit for GPIOB pin
 *	r0: port
 *	r1: value
 */
gpiob_set_bit:
	push {lr}
	push {r0-r4}
	ldr r2, =(gpiob + gpio_data_reg)
	bl gpio_set_bit
	pop {r0-r4}
	pop {pc}

/**
 * Set pull-up/pull-down for GPIOA
 *	r0: port
 *	r1: value
 */
gpioa_set_pupd:
	push {lr}
	push {r0-r4}
	ldr r2, =(gpioa + gpio_pupd_reg)
	bl gpio_set_pupd
	pop {r0-r4}
	pop {pc}

/**
 * Set pull-up/pull-down for GPIOA
 *	r0: port
 *	r1: value
 */
gpiob_set_pupd:
	push {lr}
	push {r0-r4}
	ldr r2, =(gpiob + gpio_pupd_reg)
	bl gpio_set_pupd
	pop {r0-r4}
	pop {pc}

/** Private */

/**
 * Set mode for GPIO
 *	r0: port
 *	r1: value
 *	r2: reg_addr
 */
gpio_set_mode:
	// Compute bit masks
	movs r4, #2
	muls r0, r0, r4
	movs r4, #0b11
	lsls r4, r4, r0
	mvns r4, r4
	lsls r1, r1, r0
	// Set bit
	ldr r3, [r2]
	ands r3, r3, r4
	orrs r3, r3, r1
	str r3, [r2]
	bx lr

/**
 * Set mode for GPIO
 *	r0: port
 *	r1: value
 *	r2: reg_addr
 */
gpio_set_bit:
	// Compute bit masks
	movs r4, #0b1
	lsls r4, r4, r0
	mvns r4, r4
	lsls r1, r1, r0
	// Set bit
	ldr r3, [r2]
	ands r3, r3, r4
	orrs r3, r3, r1
	str r3, [r2]
	bx lr

/**
 * Set pull-up/pull-down
 *	r0: port
 *	r1: value
 *	r2: reg_addr
 */
gpio_set_pupd:
	// Compute bit masks
	movs r4, #2
	muls r0, r0, r4
	movs r4, #0b11
	lsls r4, r4, r0
	mvns r4, r4
	lsls r1, r1, r0
	// Set bit
	ldr r3, [r2]
	ands r3, r3, r4
	orrs r3, r3, r1
	str r3, [r2]
	bx lr

.end
