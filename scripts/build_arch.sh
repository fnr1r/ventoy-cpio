#!/usr/bin/env bash
set -euo pipefail
set -x

HERE="$(dirname "$(readlink -f -- "$0")")"

. "$HERE/lib_build_cpio.sh"

ARCH="$2"
MY_DIR="$REPO_DIR/arch/$ARCH"

XZ_FLAGS=(-c -e -9)

prepare_files_x86() {
    cp -aL \
        "$REPO_DIR/tools/busybox/dist/x86_64_ash" \
        64h
    cp -aL \
        "$REPO_DIR/tools/busybox/dist/i386_ash" \
        ash
    xz "${XZ_FLAGS[@]}" \
        "$REPO_DIR/tools/busybox/dist/i386_busybox" \
        > busybox32.xz
    xz "${XZ_FLAGS[@]}" \
        "$REPO_DIR/tools/busybox/dist/x86_64_busybox" \
        > busybox64.xz
    cp -a \
        "$REPO_DIR/tools/xz-embedded/dist/i386/xzminidec" \
        xzminidec32
    cp -a \
        "$REPO_DIR/tools/xz-embedded/dist/x86_64/xzminidec" \
        xzminidec64
}

prepare_files() {
    mkdir ventoy
    pushd ventoy > /dev/null
    mkdir busybox
    pushd busybox > /dev/null
    "prepare_files_$ARCH"
    popd > /dev/null
    xz "${XZ_FLAGS[@]}" \
        "$REPO_DIR/build/tool_${ARCH}.cpio" \
        > "tool_${ARCH}.cpio.xz"
    popd > /dev/null
}

main "$@"
