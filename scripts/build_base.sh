#!/usr/bin/env bash
set -euo pipefail

HERE="$(dirname "$(readlink -f -- "$0")")"

. "$HERE/lib_build_cpio.sh"

MY_DIR="$REPO_DIR/base"

prepare_files() {
    mkdir ventoy
    cp -a "$BUILD_DIR"/{hook,loop}.cpio.xz ventoy
    cp -a "$BUILD_DIR"/ventoy_{chain,loop}.sh.xz ventoy
    cp -a "$MY_DIR"/ventoy/init* ventoy
    cp -a "$MY_DIR"/sbin .
    ln -s sbin/init init
    ln -s sbin/init linuxrc
}

main "$@"
