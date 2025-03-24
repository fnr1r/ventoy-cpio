#!/usr/bin/env bash
set -euo pipefail

HERE="$(dirname "$(readlink -f -- "$0")")"

. "$HERE/../../repo.sh"
# shellcheck source=../../scripts/tool_build.sh
. "$SCRIPTS_DIR/tool_build.sh"

ARCH=""
CC=""
CFLAGS=""
CONFIGURE_OPTS=()
MAKEBIN=()
STRIP_CMD=()

argparse() {
    ARCH="$1"
    MAKEBIN=("${@:2}")

    CFLAGS="-Os"

    case $ARCH in
        aarch64)
            CC="aarch64-linux-gcc"
            CONFIGURE_OPTS=(--host=aarch64-linux-uclibc)
            STRIP_CMD=(aarch64-linux-strip)
            ;;
        i386)
            CC="gcc -m32"
            CONFIGURE_OPTS=(--host=i386-linux-gnu)
            STRIP_CMD=(strip)
            echo "Broken :("
            exit 69
            ;;
        mips64el)
            CC="mips64el-linux-musl-gcc"
            CONFIGURE_OPTS=(--host=mips64el-linux-musl)
            STRIP_CMD=(mips64el-linux-musl-strip)
            ;;
        x86_64)
            CC="musl-gcc"
            CONFIGURE_OPTS=(--host=x86_64-linux-musl)
            STRIP_CMD=(strip)
            ;;
        *)
            exit 69
            ;;
    esac

    BUILD_SUB_DIR="$ARCH"
    TARGET_SUB_DIR="$ARCH"
}

copysrc() {
    cp -ar --reflink=auto src/. "$WORK_DIR"
}

undefine_fuse_kernel_int() {
    sed '/#define *__u64/d' -i include/fuse_kernel.h
    sed '/#define *__s64/d' -i include/fuse_kernel.h

    sed  's/__u64/uint64_t/g'    -i include/fuse_kernel.h
    sed  's/__s64/int64_t/g'    -i include/fuse_kernel.h
}

prepare() {
    pushd libfuse > /dev/null
    if [[ "$ARCH" == "aarch64" ]]; then
        undefine_fuse_kernel_int
    fi
    popd > /dev/null
}

TARGET_BIN="vtoy_fuse_iso"

build() {
    local prefix="$PWD/prefix"
    pushd libfuse > /dev/null
    CC="$CC" CFLAGS="$CFLAGS" ./configure \
        "${CONFIGURE_OPTS[@]}" --prefix="$prefix" \
        --enable-lib --enable-static=yes --enable-shared=no \
        --enable-util=no --enable-example=no
    "${MAKEBIN[@]}" install
    popd > /dev/null
    $CC $CFLAGS -static -D_FILE_OFFSET_BITS=64 \
        "-I$prefix/include" "-L$prefix/lib" \
        -lfuse "$prefix/lib/libfuse.a" "$prefix/lib/libulockmgr.a" "libfuse/lib/"*".o" \
        -o "$TARGET_BIN" "$TARGET_BIN.c"
}

package() {
    cp -ar "$TARGET_BIN" "$TARGET_DIR/$TARGET_BIN.debug"
    "${STRIP_CMD[@]}" "$TARGET_BIN"
    mv "$TARGET_BIN" "$TARGET_DIR/$TARGET_BIN"
}

main "$@"
