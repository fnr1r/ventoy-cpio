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
STRIP_CMD=()

argparse() {
    ARCH="$1"
    MAKEBIN=("${@:2}")

    CFLAGS="-Wall -Os -static"
    # for diet: -D_BSD_SOURCE -D_GNU_SOURCE
    # but it's still broken :(

    case $ARCH in
        aarch64)
            CC="aarch64-linux-gcc"
            STRIP_CMD=(aarch64-linux-strip)
            ;;
        i386)
            CC="gcc -m32"
            STRIP_CMD=(strip)
            ;;
        mips64el)
            echo "broken (for now) :("
            exit 69
            CC="diet mips64el-linux-musl-gcc"
            CFLAGS+=" -D_BSD_SOURCE -D_GNU_SOURCE"
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

TARGET_BIN="vblade"

build() {
    "${MAKEBIN[@]}" CC="$CC" CFLAGS="$CFLAGS"
}

package() {
    cp -ar "$TARGET_BIN" "$TARGET_DIR/$TARGET_BIN.debug"
    "${STRIP_CMD[@]}" "$TARGET_BIN"
    mv "$TARGET_BIN" "$TARGET_DIR/$TARGET_BIN"
}

main "$@"
