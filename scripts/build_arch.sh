#!/usr/bin/env bash
set -euo pipefail

HERE="$(dirname "$(readlink -f -- "$0")")"

. "$HERE/lib_build_cpio.sh"

ARCH="$2"
MY_DIR="$CRDIR/arch/$ARCH"

prepare_files() {
    cp -r "$MY_DIR"/ventoy . 
}

main "$@"
