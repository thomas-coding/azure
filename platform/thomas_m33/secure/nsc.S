
/*
 * Copyright (c) 2021-2031, Jinping Wu. All rights reserved.
 *
 * SPDX-License-Identifier: MIT
 */

	.thumb_func
	.section .nsc,"ax"
	.globl   nsc_call
	.code 16
	.align 2
nsc_call:
	sg
	mov	  r5, lr
	bl    nsc_call_function
	bxns  r5

