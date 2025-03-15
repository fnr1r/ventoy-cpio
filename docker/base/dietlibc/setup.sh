#!/usr/bin/env bash
set -euo pipefail

HERE="$(dirname "$(readlink -f -- "$0")")"
JOBS="$(nproc)"

download_and_extract() {
    url="$1"
    src="$2"
    dest="$3"
    url_file="$(basename "$1")"

    echo "$url"

    if ! [[ -f "$url_file" ]]; then
        echo "  downloading"
        wget -q "$url"
    else
        echo "  skipping download"
    fi

    if ! [[ -f "$url_file.checked" ]]; then
        printf "  verifying: "
        sha256sum -c "$url_file.sha256"
        #touch "$url_file.checked"
    else
        echo "  skipping verification"
    fi

    tmpd="$(mktemp -d)"
    pushd "$tmpd" > /dev/null
    echo "  extracting"
    tar -xf "$HERE/$url_file"
    mv "$src" "$dest"
    echo "  done"
    popd > /dev/null
    rm -r "$tmpd"
}

main() {
    cd "$HERE"
    dest="/tmp/dietlibc_build"
    download_and_extract "https://www.fefe.de/dietlibc/dietlibc-0.34.tar.xz" "dietlibc-0.34" "$dest"
    pushd "$dest" > /dev/null
    make ARCH=x86_64 CC=gcc all
    make ARCH=i386 CFLAGS+="-m32" all
    make ARCH=aarch64 CROSS=aarch64-linux-gnu- all
    make ARCH=mips64 CROSS=mips64el-linux-musl- all
    make ARCH=x86_64 CC=gcc install
    make ARCH=i386 CFLAGS+="-m32" install
    make ARCH=aarch64 CROSS=aarch64-linux-gnu- install
    make ARCH=mips64 CROSS=mips64el-linux-musl- install
    popd > /dev/null
    rm -r "$dest"
    eval "exit 0"
}

main "$@"
