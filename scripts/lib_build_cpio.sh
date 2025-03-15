#!/usr/bin/env bash
set -euo pipefail

SRCHERE="$(dirname "$(readlink -f -- "${BASH_SOURCE[0]}")")"

. "$SRCHERE/../repo.sh"

export BUILD_DIR="$REPO_DIR/build"

TARGET="$1"
TMP_DIR="$REPO_DIR/$TARGET.temp"

temp_dir_go() {
    if [[ -d "$TMP_DIR" ]]; then
        rm -r "$TMP_DIR"
    fi
    mkdir -p "$TMP_DIR"
    cd "$TMP_DIR"
}

pack_cpio() {
    find . | cpio -o -H newc --owner=root:root > "$REPO_DIR/$TARGET"
}

temp_dir_clean() {
    rm -r "$TMP_DIR"
}

prepare_files() {
    echo "prepare_files is not defined!"
    eval "exit 69"
}

main() {
    temp_dir_go
    prepare_files
    pack_cpio
    temp_dir_clean
    eval "exit 0"
}
