/*
 * Copyright (c) 2016, ARM Limited and Contributors. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * Neither the name of ARM nor the names of its contributors may be used
 * to endorse or promote products derived from this software without specific
 * prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */
#include <arch.h>
#include <asm_macros.S>
#include <cpu_macros.S>
#include <css_def.h>

	.weak	plat_secondary_cold_boot_setup
	.weak	plat_get_my_entrypoint
	.globl	css_calc_core_pos_swap_cluster
	.weak	plat_is_my_cpu_primary

	/* ---------------------------------------------------------------------
	 * void plat_secondary_cold_boot_setup(void);
	 * In the normal boot flow, cold-booting secondary
	 * CPUs is not yet implemented and they panic.
	 * ---------------------------------------------------------------------
	 */
func plat_secondary_cold_boot_setup
	/* TODO: Implement secondary CPU cold boot setup on CSS platforms */
cb_panic:
	b	cb_panic
endfunc plat_secondary_cold_boot_setup

	/* ---------------------------------------------------------------------
	 * uintptr_t plat_get_my_entrypoint (void);
	 *
	 * Main job of this routine is to distinguish between a cold and a warm
	 * boot. On CSS platforms, this distinction is based on the contents of
	 * the Trusted Mailbox. It is initialised to zero by the SCP before the
	 * AP cores are released from reset. Therefore, a zero mailbox means
	 * it's a cold reset.
	 *
	 * This functions returns the contents of the mailbox, i.e.:
	 *  - 0 for a cold boot;
	 *  - the warm boot entrypoint for a warm boot.
	 * ---------------------------------------------------------------------
	 */
func plat_get_my_entrypoint
	ldr	r0, =PLAT_ARM_TRUSTED_MAILBOX_BASE
	ldr	r0, [r0]
	bx	lr
endfunc plat_get_my_entrypoint

	/* -----------------------------------------------------------
	 * unsigned int css_calc_core_pos_swap_cluster(u_register_t mpidr)
	 * Utility function to calculate the core position by
	 * swapping the cluster order. This is necessary in order to
	 * match the format of the boot information passed by the SCP
	 * and read in plat_is_my_cpu_primary below.
	 * -----------------------------------------------------------
	 */
func css_calc_core_pos_swap_cluster
	and	r1, r0, #MPIDR_CPU_MASK
	and	r0, r0, #MPIDR_CLUSTER_MASK
	eor	r0, r0, #(1 << MPIDR_AFFINITY_BITS)  // swap cluster order
	add	r0, r1, r0, LSR #6
	bx	lr
endfunc css_calc_core_pos_swap_cluster

	/* -----------------------------------------------------
	 * unsigned int plat_is_my_cpu_primary (void);
	 *
	 * Find out whether the current cpu is the primary
	 * cpu (applicable ony after a cold boot)
	 * -----------------------------------------------------
	 */
func plat_is_my_cpu_primary
	mov	r10, lr
	bl	plat_my_core_pos
	ldr	r1, =SCP_BOOT_CFG_ADDR
	ldr	r1, [r1]
	ubfx	r1, r1, #PLAT_CSS_PRIMARY_CPU_SHIFT, \
			#PLAT_CSS_PRIMARY_CPU_BIT_WIDTH
	cmp	r0, r1
	moveq	r0, #1
	movne	r0, #0
	bx	r10
endfunc plat_is_my_cpu_primary
