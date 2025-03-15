#!/usr/bin/env bash
set -euo pipefail

HERE="$(dirname "$(readlink -f -- "$0")")"

. "$HERE/../../repo.sh"
# shellcheck source=../../scripts/tool_build.sh
. "$SCRIPTS_DIR/tool_build.sh"

ARCH=""
DIST_DIR=""
MAKEBIN=()
MAKEOPTS=()
STRIP_CMD=()

argparse() {
    ARCH="$1"
    DIST_DIR="$HERE/dist/$ARCH"
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
}

copysrc() {
    cp -ar src/. "$TMP_DIR"
}

TARGET_BIN="xzminidec"

build() {
    cd userspace
    MAKE=("${MAKEBIN[@]}" "${MAKEOPTS[@]}")
    "${MAKE[@]}" "$TARGET_BIN"
}

package() {
    mkdir -p "$DIST_DIR"
    cp -ar "$TARGET_BIN" "$DIST_DIR/$TARGET_BIN.debug"
    "${STRIP_CMD[@]}" "$TARGET_BIN"
    mv "$TARGET_BIN" "$DIST_DIR/$TARGET_BIN"
}

main "$@"
