#
# Copyright 2020, DornerWorks
# Copyright 2020, Data61, CSIRO (ABN 41 687 119 230)
#
# SPDX-License-Identifier: GPL-2.0-only
#

cmake_minimum_required(VERSION 3.7.2)

declare_platform(hw-zsipos KernelPlatformHWZsipos PLAT_HW_ZSIPOS KernelArchRiscV)

if(KernelPlatformHWZsipos)
    if("${KernelSel4Arch}" STREQUAL riscv32)
        declare_seL4_arch(riscv32)
    elseif("${KernelSel4Arch}" STREQUAL riscv64)
        declare_seL4_arch(riscv64)
    else()
        fallback_declare_seL4_arch_default(riscv64)
    endif()
    config_set(KernelRiscVPlatform RISCV_PLAT "hw-zsipos")
    config_set(KernelPlatformFirstHartID FIRST_HART_ID 0)
    if(KernelSel4ArchRiscV32)
        list(APPEND KernelDTSList "tools/dts/hw-zsipos32.dts")
        list(APPEND KernelDTSList "src/plat/hifive/overlay-hifive.dts")
    else()
        list(APPEND KernelDTSList "tools/dts/hw-zsipos.dts")
        list(APPEND KernelDTSList "src/plat/hw-zsipos/overlay-hw-zsipos.dts")
    endif()
    execute_process(COMMAND python "${CMAKE_CURRENT_LIST_DIR}/getirqcount.py" OUTPUT_VARIABLE RISCV_IRQ_COUNT)
    declare_default_headers(
        TIMER_FREQUENCY 1000000llu PLIC_MAX_NUM_INT "${RISCV_IRQ_COUNT}"
        INTERRUPT_CONTROLLER drivers/irq/hw-zsipos.h
    )
else()
    unset(KernelPlatformFirstHartID CACHE)
endif()
