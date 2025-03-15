#!/usr/bin/env bash
set -euo pipefail

HERE="$(dirname "$(readlink -f -- "$0")")"

. "$HERE/../../repo.sh"
# shellcheck source=../../scripts/tool_build.sh
. "$SCRIPTS_DIR/tool_build.sh"

main() {
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

    cd "$HERE"
    TMP_DIR="$(mktemp -d)"

    cp -ar src/. "$TMP_DIR"

    pushd "$TMP_DIR/userspace" > /dev/null

    MAKE=("${MAKEBIN[@]}" "${MAKEOPTS[@]}")

    TARGET_BIN="xzminidec"

    "${MAKE[@]}" "$TARGET_BIN"

    mkdir -p "$DIST_DIR"
    cp -ar "$TARGET_BIN" "$DIST_DIR/$TARGET_BIN.debug"
    "${STRIP_CMD[@]}" "$TARGET_BIN"
    mv "$TARGET_BIN" "$DIST_DIR/$TARGET_BIN"

    popd > /dev/null
    rm -r "$TMP_DIR"

    eval "exit 0"
}

main "$@"
