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
    MAKEOPTS=()
    CFLAGS="-Os -flto "

    case $ARCH in
        aarch64)
            CC="aarch64-linux-gnu-gcc"
            STRIP_CMD=(aarch64-linux-gnu-strip)
            ;;
        i386)
            CFLAGS+="-m32"
            STRIP_CMD=(strip)
            ;;
        mips64el)
            CC="mips64el-linux-musl-gcc"
            STRIP_CMD=(mips64el-linux-musl-strip)
            MAKEOPTS+=(
                "CC=$CC"
            )
            ;;
        x86_64)
            STRIP_CMD=(strip --strip-all)
            ;;
        *)
            exit 69
            ;;
    esac

    cd "$HERE"
    TMP_DIR="$(mktemp -d)"

    cp -ar src/. "$TMP_DIR"

    pushd "$TMP_DIR/squashfs-tools" > /dev/null

    #MAKE=("${MAKEBIN[@]}" "${MAKEOPTS[@]}")

    TARGET_BIN="unsquashfs"
    env "${MAKEOPTS[@]}" "${MAKEBIN[@]}" \
        "$TARGET_BIN"

    mkdir -p "$DIST_DIR"
    cp -ar "$TARGET_BIN" "$DIST_DIR/$TARGET_BIN.debug"
    "${STRIP_CMD[@]}" "$TARGET_BIN"
    cp -ar "$TARGET_BIN" "$DIST_DIR/$TARGET_BIN.stripped"
    upx "$TARGET_BIN"
    mv "$TARGET_BIN" "$DIST_DIR/$TARGET_BIN"

    popd > /dev/null
    rm -r "$TMP_DIR"

    eval "exit 0"
}

main "$@"
