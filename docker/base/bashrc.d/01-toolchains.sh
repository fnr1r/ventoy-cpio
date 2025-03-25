#!/usr/bin/env bash
AARCH64_TOOLCHAIN="/opt/aarch64--uclibc--stable-2020.08-1"
MIPS64EL_TOOLCHAIN="/opt/mips64el-linux-gnu-musl-gcc7.3.0"
PATH="${PATH}:${AARCH64_TOOLCHAIN}/bin:${MIPS64EL_TOOLCHAIN}/bin"
export PATH
