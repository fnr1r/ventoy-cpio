#!/usr/bin/env bash
set -euo pipefail

HERE="$(dirname "$(readlink -f -- "$0")")"

. "$HERE/../../repo.sh"
# shellcheck source=../../scripts/tool_build.sh
. "$SCRIPTS_DIR/tool_build.sh"

ARCH=""
CC=""
CFLAGS=""
MAKEBIN=()
LDFLAGS=""
STRIP_CMD=()

argparse() {
    ARCH="$1"
    MAKEBIN=("${@:2}")
    CFLAGS="-Os"
    LDFLAGS="-static -L/opt/diet/lib-x86_64/libpthread.a"

    case $ARCH in
        aarch64)
            CC="aarch64-linux-gnu-gcc"
            STRIP_CMD=(aarch64-linux-gnu-strip)
            ;;
        i386)
            CC="gcc -m32"
            STRIP_CMD=(strip)
            ;;
        mips64el)
            CC="mips64el-linux-musl-gcc"
            STRIP_CMD=(mips64el-linux-musl-strip)
            ;;
        x86_64)
            CC="musl-gcc"
            STRIP_CMD=(strip --strip-all)
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

TARGET_BIN="programs/lz4"

build() {
    CFLAGS="$CFLAGS" LDFLAGS="$LDFLAGS" "${MAKEBIN[@]}" "CC=$CC" "BUILD_SHARED=no"
}

package() {
    cp -ar "$TARGET_BIN" "$TARGET_DIR/lz4cat.debug"
    "${STRIP_CMD[@]}" "$TARGET_BIN"
    mv "$TARGET_BIN" "$TARGET_DIR/lz4cat"
}

main "$@"
