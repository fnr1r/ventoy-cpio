#!/usr/bin/env bash
set -euo pipefail

HERE="$(dirname "$(readlink -f -- "$0")")"

. "$HERE/lib_build_cpio.sh"

ARCH="$2"
#MY_DIR="$REPO_DIR/arch/$ARCH"

#XZ_FLAGS=(-c -e -9)

copy_with() {
    local arch="$1" suffix="$2"
    cp -a \
        "$REPO_DIR/tools/device-mapper/dist/${arch}/dmsetup" \
        "dmsetup${suffix}"
    cp -a \
        "$REPO_DIR/tools/squashfs/dist/${arch}/unsquashfs" \
        "unsquashfs_${suffix}"
    cp -a \
        "$REPO_DIR/tools/vtoytool/dist/${arch}/vtoytool" \
        "vtoytool/00/vtoytool_${suffix}"
    cp -a \
        "$REPO_DIR/tools/zstd/dist/${arch}/zstdcat" \
        "zstdcat${suffix}"
}

prepare_files_arm64() {
    copy_with aarch64 aa64
}

prepare_files_x86() {
    copy_with i386 32
    copy_with x86_64 64
    cp -a "$REPO_DIR/tools_extra/vtoytool_install.sh" .
}

prepare_files_mips64() {
    copy_with mips64el m64e
}

prepare_files() {
    mkdir tool
    pushd tool > /dev/null
    mkdir -p vtoytool/{00,01,02}
    "prepare_files_$ARCH"
    cp -a \
        "$REPO_DIR/tools/vtoytool/dist/x86_64/vtoytool" \
        "vtoytool/01/vtoytool_64"
    cp -a \
        "$REPO_DIR/tools/vtoytool/dist/x86_64/vtoytool" \
        "vtoytool/02/vtoytool_64"
    popd > /dev/null
}

main "$@"
