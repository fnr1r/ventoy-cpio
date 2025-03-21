#!/usr/bin/env bash
set -euo pipefail

HERE="$(dirname "$(readlink -f -- "$0")")"

. "$HERE/lib_build_cpio.sh"

ARCH="$2"
#MY_DIR="$REPO_DIR/arch/$ARCH"

#XZ_FLAGS=(-c -e -9)

copy_with() {
    local arch="$1" suffix="$2"
    # TODO
}

prepare_files_arm64() {
    cp -a \
        "$REPO_DIR/tools/device-mapper/dist/aarch64/dmsetup" \
        dmsetupaa64
    cp -a \
        "$REPO_DIR/tools/squashfs/dist/aarch64/unsquashfs" \
        unsquashfs64
    cp -a \
        "$REPO_DIR/tools/zstd/dist/aarch64/zstdcat" \
        zstdcataa64
}

prepare_files_x86() {
    cp -a \
        "$REPO_DIR/tools/device-mapper/dist/i386/dmsetup" \
        dmsetup32
    cp -a \
        "$REPO_DIR/tools/device-mapper/dist/x86_64/dmsetup" \
        dmsetup64
    cp -a \
        "$REPO_DIR/tools/squashfs/dist/i386/unsquashfs" \
        unsquashfs32
    cp -a \
        "$REPO_DIR/tools/squashfs/dist/x86_64/unsquashfs" \
        unsquashfs64
    cp -a \
        "$REPO_DIR/tools/zstd/dist/i386/zstdcat" \
        zstdcat32
    cp -a \
        "$REPO_DIR/tools/zstd/dist/x86_64/zstdcat" \
        zstdcat64
}

prepare_files() {
    mkdir tool
    pushd tool > /dev/null
    "prepare_files_$ARCH"
    popd > /dev/null
}

main "$@"
