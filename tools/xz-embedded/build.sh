#!/usr/bin/env bash
set -euo pipefail

HERE="$(dirname "$(readlink -f -- "$0")")"

. "$HERE/../../repo.sh"
# shellcheck source=../../scripts/tool_build.sh
. "$SCRIPTS_DIR/tool_build.sh"

ARCH=""
MAKEBIN=()
MAKEOPTS=()
STRIP_CMD=()

argparse() {
    ARCH="$1"
    MAKEBIN=("${@:2}")
    MAKEOPTS=(-f "$HERE/arch.mk")

    case $ARCH in
        aarch64)
            STRIP_CMD=(aarch64-linux-gnu-strip)
            ;;
        i386)
            STRIP_CMD=(strip)
            ;;
        mips64el)
            STRIP_CMD=(mips64el-linux-musl-strip)
            ;;
        x86_64)
            STRIP_CMD=(strip --strip-all)
            ;;
        *)
            exit 69
            ;;
    esac

    MAKEOPTS+=(
        "ARCH=$ARCH"
    )

    BUILD_SUB_DIR="$ARCH"
    TARGET_SUB_DIR="$ARCH"
}

copysrc() {
    cp -ar --reflink=auto src/. "$WORK_DIR"
}

TARGET_BIN="xzminidec"

build() {
    cd userspace
    MAKE=("${MAKEBIN[@]}" "${MAKEOPTS[@]}")
    MAKEFLAGS="" "${MAKE[@]}" "$TARGET_BIN"
}

package() {
    cp -ar "$TARGET_BIN" "$TARGET_DIR/$TARGET_BIN.debug"
    "${STRIP_CMD[@]}" "$TARGET_BIN"
    mv "$TARGET_BIN" "$TARGET_DIR/$TARGET_BIN"
}

main "$@"
