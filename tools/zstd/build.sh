#!/usr/bin/env bash
set -euo pipefail

HERE="$(dirname "$(readlink -f -- "$0")")"

. "$HERE/../../repo.sh"
# shellcheck source=../../scripts/tool_build.sh
. "$SCRIPTS_DIR/tool_build.sh"

ARCH=""
CC=""
MAKEBIN=()
MAKEOPTS=()
STRIP_CMD=()

argparse() {
    ARCH="$1"
    MAKEBIN=("${@:2}")
    MAKEOPTS=()

    case $ARCH in
        aarch64)
            CC="diet aarch64-linux-gcc"
            STRIP_CMD=(aarch64-linux-strip)
            ;;
        i386)
            CC="diet gcc -m32"
            STRIP_CMD=(strip)
            ;;
        mips64el)
            CC="diet mips64el-linux-musl-gcc"
            STRIP_CMD=(mips64el-linux-musl-strip)
            ;;
        x86_64)
            CC="diet gcc"
            STRIP_CMD=(strip --strip-all)
            ;;
        *)
            exit 69
            ;;
    esac

    MAKEOPTS+=(
        "CC=$CC"
    )

    BUILD_SUB_DIR="$ARCH"
    TARGET_SUB_DIR="$ARCH"
}

copysrc() {
    cp -ar --reflink=auto src/. "$WORK_DIR"
}

TARGET_BIN="zstd"

build() {
    cd programs
    MAKE=("${MAKEBIN[@]}" "${MAKEOPTS[@]}")
    "${MAKE[@]}" "$TARGET_BIN"
}

package() {
    cp -ar "$TARGET_BIN" "$TARGET_DIR/zstdcat.debug"
    "${STRIP_CMD[@]}" "$TARGET_BIN"
    mv "$TARGET_BIN" "$TARGET_DIR/zstdcat"
}

main "$@"
