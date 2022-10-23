/*
 * Copyright (c) 2021-2031, Jinping Wu. All rights reserved.
 *
 * SPDX-License-Identifier: MIT
 */

#include <sau.h>
#include <stdio.h>

void nsc_call_function(void)
{
	printf("Enter nsc called!\n");
}

/* Refer README.md memory map define */
void call_ns_world(void)
{
	/* Set non-secure world vector base address */
	*(volatile unsigned int *)0xe002ed08=0x10200000;

	/* Set non-secure msp */
	asm volatile ("ldr r0, =0x10200000");
	asm volatile ("ldr r1, [r0]");
	asm volatile ("msr msp_ns, r1");

	/* Get non-secure entry */
	asm volatile ("ldr r0, =0x10200004");
	asm volatile ("ldr r1, [r0]");
	/* Bit0 set to 0, indicate enter non-secure state*/
	asm volatile ("bic r1,r1,#0x1");
	asm volatile ("bxns r1");
}

void platform_init(void)
{
	sau_init();
}

int main(void)
{
	platform_init();
	call_ns_world();
	while(1) {};
	return 0;
}
