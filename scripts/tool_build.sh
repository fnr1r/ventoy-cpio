#!/usr/bin/env bash
if [[ -z "${HERE:-}" ]]; then
    echo "HERE not defined" > /dev/stderr
    exit 1
fi
if [[ -z "${REPO_DIR:-}" ]]; then
    echo "REPO_DIR not defined" > /dev/stderr
    exit 1
fi

BUILD_DIR="$HERE/build"
DIST_DIR="$HERE/dist"

TARGET_DIR=""
TMP_DIR=""
WORK_DIR=""

BUILD_SUB_DIR=""
TARGET_SUB_DIR=""

argparse() {
    echo "argparse is not defined!"
    eval "exit 69"
}

copysrc() { :; }

prepare() { :; }

build() {
    echo "build is not defined!"
    eval "exit 69"
}

package() { :; }

postbuild() { :; }

_int_setup_1() {
    if [[ -n "$TMP_DIR" ]]; then
        return
    fi
    TMP_DIR="$(mktemp -d)"
}

_int_setup_2() {
    if [[ -n "$BUILD_SUB_DIR" ]]; then
        WORK_DIR="$BUILD_DIR/$BUILD_SUB_DIR"
        return
    fi
    WORK_DIR="$TMP_DIR"
}

_int_setup_3() {
    if [[ -n "$TARGET_SUB_DIR" ]]; then
        TARGET_DIR="$DIST_DIR/$TARGET_SUB_DIR"
        return
    fi
    TARGET_DIR="$DIST_DIR"
}

_int_setup() {
    _int_setup_1
    _int_setup_2
    if ! [[ -d "$WORK_DIR" ]]; then
        mkdir -p "$WORK_DIR"
    fi
    _int_setup_3
}

main() {
    set -euo pipefail
    argparse "$@"
    _int_setup
    cd "$HERE"
    copysrc
    pushd "$WORK_DIR" > /dev/null
    prepare
    build
    mkdir -p "$TARGET_DIR"
    package
    popd > /dev/null
    rm -r "$TMP_DIR"
    postbuild
    eval "exit 0"
}
