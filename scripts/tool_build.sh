#!/usr/bin/env bash
if [[ -z "${HERE:-}" ]]; then
    echo "HERE not defined" > /dev/stderr
    exit 1
fi
if [[ -z "${REPO_DIR:-}" ]]; then
    echo "REPO_DIR not defined" > /dev/stderr
    exit 1
fi

TMP_DIR=""

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

main() {
    set -euo pipefail
    argparse "$@"
    cd "$HERE"
    TMP_DIR="$(mktemp -d)"
    copysrc
    pushd "$TMP_DIR" > /dev/null
    prepare
    build
    package
    popd > /dev/null
    rm -r "$TMP_DIR"
    postbuild
    eval "exit 0"
}
