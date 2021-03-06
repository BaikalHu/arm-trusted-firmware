/*
 * Copyright (c) 2015-2017, ARM Limited and Contributors. All rights reserved.
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

#ifndef __FLOWCTRL_H__
#define __FLOWCTRL_H__

#include <mmio.h>
#include <tegra_def.h>

#define FLOWCTRL_HALT_CPU0_EVENTS	0x0U
#define  FLOWCTRL_WAITEVENT		(2U << 29)
#define  FLOWCTRL_WAIT_FOR_INTERRUPT	(4U << 29)
#define  FLOWCTRL_JTAG_RESUME		(1U << 28)
#define  FLOWCTRL_HALT_SCLK		(1U << 27)
#define  FLOWCTRL_HALT_LIC_IRQ		(1U << 11)
#define  FLOWCTRL_HALT_LIC_FIQ		(1U << 10)
#define  FLOWCTRL_HALT_GIC_IRQ		(1U << 9)
#define  FLOWCTRL_HALT_GIC_FIQ		(1U << 8)
#define FLOWCTRL_HALT_BPMP_EVENTS	0x4U
#define FLOWCTRL_CPU0_CSR		0x8U
#define  FLOW_CTRL_CSR_PWR_OFF_STS	(1U << 16)
#define  FLOWCTRL_CSR_INTR_FLAG		(1U << 15)
#define  FLOWCTRL_CSR_EVENT_FLAG	(1U << 14)
#define  FLOWCTRL_CSR_IMMEDIATE_WAKE	(1U << 3)
#define  FLOWCTRL_CSR_ENABLE		(1U << 0)
#define FLOWCTRL_HALT_CPU1_EVENTS	0x14U
#define FLOWCTRL_CPU1_CSR		0x18U
#define FLOWCTRL_CC4_CORE0_CTRL		0x6cU
#define FLOWCTRL_WAIT_WFI_BITMAP	0x100U
#define FLOWCTRL_L2_FLUSH_CONTROL	0x94U
#define FLOWCTRL_BPMP_CLUSTER_CONTROL	0x98U
#define  FLOWCTRL_BPMP_CLUSTER_PWRON_LOCK	(1U << 2)

#define FLOWCTRL_ENABLE_EXT		12U
#define FLOWCTRL_ENABLE_EXT_MASK	3U
#define FLOWCTRL_PG_CPU_NONCPU		0x1U
#define FLOWCTRL_TURNOFF_CPURAIL	0x2U

static inline uint32_t tegra_fc_read_32(uint32_t off)
{
	return mmio_read_32(TEGRA_FLOWCTRL_BASE + off);
}

static inline void tegra_fc_write_32(uint32_t off, uint32_t val)
{
	mmio_write_32(TEGRA_FLOWCTRL_BASE + off, val);
}

void tegra_fc_cluster_idle(uint32_t midr);
void tegra_fc_cpu_powerdn(uint32_t mpidr);
void tegra_fc_cluster_powerdn(uint32_t midr);
void tegra_fc_soc_powerdn(uint32_t midr);
void tegra_fc_cpu_on(int cpu);
void tegra_fc_cpu_off(int cpu);
void tegra_fc_lock_active_cluster(void);
void tegra_fc_reset_bpmp(void);

#endif /* __FLOWCTRL_H__ */
