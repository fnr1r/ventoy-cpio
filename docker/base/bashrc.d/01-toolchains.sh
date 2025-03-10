#!/usr/bin/env bash
AARCH64_TOOLCHAIN="/opt/gcc-linaro-7.4.1-2019.02-x86_64_aarch64-linux-gnu"
MIPS_TOOLCHAIN="/opt/mips-loongson-gcc7.3-2019.06-29-linux-gnu"
PATH="${PATH}:${AARCH64_TOOLCHAIN}/bin:${MIPS_TOOLCHAIN}/bin"
