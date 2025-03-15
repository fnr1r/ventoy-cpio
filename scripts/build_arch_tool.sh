#!/usr/bin/env bash
set -euo pipefail
set -x

HERE="$(dirname "$(readlink -f -- "$0")")"

. "$HERE/lib_build_cpio.sh"

ARCH="$2"
#MY_DIR="$REPO_DIR/arch/$ARCH"

#XZ_FLAGS=(-c -e -9)

prepare_files_x86() {
    cp -a \
        "$REPO_DIR/tools/device-mapper/dist/i386/dmsetup" \
        dmsetup32
    cp -a \
        "$REPO_DIR/tools/device-mapper/dist/x86_64/dmsetup" \
        dmsetup64
    cp -a \
        "$REPO_DIR/tools/zstd/dist/i386/zstdcat" \
        zstdcat32
    cp -a \
        "$REPO_DIR/tools/zstd/dist/x86_64/zstdcat" \
        zstdcat64
    #xz "${XZ_FLAGS[@]}" \
    #    "$REPO_DIR/tools/device-mapper/dist/${ARCH}_xzcat" \
    #    > tools/xzcat.xz

    #xz "${XZ_FLAGS[@]}" \
    #    "$REPO_DIR/tools/device-mapper/dist/${ARCH}_64/dmsetup" \
    #    > tools/dmsetup.xz
    #xz "${XZ_FLAGS[@]}" \
    #    "$REPO_DIR/tools/zstd/dist/${ARCH}_64/zstdcat" \
    #    > tools/zstdcat.xz
}

prepare_files() {
    mkdir tool
    pushd tool > /dev/null
    "prepare_files_$ARCH"
    popd > /dev/null
}

main "$@"
