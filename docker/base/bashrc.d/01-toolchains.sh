#!/usr/bin/env bash
AARCH64_GNU_TOOLCHAIN="/opt/gcc-linaro-7.4.1-2019.02-x86_64_aarch64-linux-gnu"
AARCH64_UCLIBC_TOOLCHAIN="/opt/aarch64--uclibc--stable-2020.08-1"
MIPS_TOOLCHAIN="/opt/mips-loongson-gcc7.3-2019.06-29-linux-gnu"
MIPS64EL_TOOLCHAIN="/opt/mips64el-linux-gnu-musl-gcc7.3.0"
PATH="${PATH}:${AARCH64_GNU_TOOLCHAIN}/bin:${AARCH64_UCLIBC_TOOLCHAIN}/bin:${MIPS_TOOLCHAIN}/bin:${MIPS64EL_TOOLCHAIN}/bin"
export PATH
