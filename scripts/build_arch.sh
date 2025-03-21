#!/usr/bin/env bash
set -euo pipefail

HERE="$(dirname "$(readlink -f -- "$0")")"

. "$HERE/lib_build_cpio.sh"

ARCH="$2"

XZ_FLAGS=(-c -e -9)

copy_with() {
    local arch="$1" suffix="$2"
    xz "${XZ_FLAGS[@]}" \
        "$REPO_DIR/tools/busybox/dist/${arch}_busybox" \
        > "busybox${suffix}.xz"
    cp -a \
        "$REPO_DIR/tools/vtchmod/dist/${arch}/vtchmod" \
        "vtchmod${suffix}"
    cp -a \
        "$REPO_DIR/tools/xz-embedded/dist/${arch}/xzminidec" \
        "xzminidec${suffix}"
}

prepare_files_arm64() {
    cp -aL \
        "$REPO_DIR/tools/busybox/dist/aarch64_ash" \
        a64
    copy_with aarch64 aa64
}

prepare_files_mips64el() {
    cp -aL \
        "$REPO_DIR/tools/busybox/dist/x86_64_ash" \
        ash
    copy_with mips64el m64e
}

prepare_files_x86() {
    cp -aL \
        "$REPO_DIR/tools/busybox/dist/x86_64_ash" \
        64h
    cp -aL \
        "$REPO_DIR/tools/busybox/dist/i386_ash" \
        ash
    copy_with x86_64 64
    copy_with i386 32
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
        > "tool.cpio.xz"
    popd > /dev/null
}

main "$@"
