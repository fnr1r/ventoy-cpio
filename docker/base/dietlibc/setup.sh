#!/usr/bin/env bash
set -euo pipefail

HERE="$(dirname "$(readlink -f -- "$0")")"
JOBS="$(nproc)"

TMP_BUILD="/tmp/dietlibc_build"
TMP_DOWNLOAD="/tmp/dietlibc_download"

NAME="dietlibc"
VERSION="0.34"

SRC_DIR="$NAME-$VERSION"
SRC_FILENAME="$SRC_DIR.tar.xz"
SRC_URL="https://www.fefe.de/$NAME/$SRC_FILENAME"

MAKEOPTS=(-j "$JOBS")

download() {
    local url="$1"
    local dest="$2"

    echo "$url"

    if ! [[ -f "$dest" ]]; then
        echo "  downloading"
        wget -q "$url" -O "$dest"
    else
        echo "  skipping download"
    fi

    if ! [[ -f "$dest.skip_check" ]]; then
        printf "  verifying: "
        sha256sum -c "$dest.sha256"
    else
        echo "  skipping verification"
    fi
}

download_and_extract() {
    local url="$1"
    local src="$2"
    local dest="$3"
    local url_file_dest="$TMP_DOWNLOAD/$(basename "$1")"
    download "$url" "$url_file_dest"

    local tmpd="$(mktemp -d)"
    pushd "$tmpd" > /dev/null
    echo "  extracting"
    tar xf "$url_file_dest"
    mv "$src" "$dest"
    echo "  done"
    popd > /dev/null
    rm -r "$tmpd"
}

xmake() {
    make "${MAKEOPTS[@]}" "$@"
}

build_default() {
    # shellcheck disable=SC2034
    local makeopts_x86_64=(ARCH=x86_64 CC=gcc)
    # shellcheck disable=SC2034
    #local makeopts_i386=(ARCH=i386 EXTRACFLAGS="-m32")
    # shellcheck disable=SC2034
    local makeopts_aarch64=(ARCH=aarch64 CROSS=aarch64-linux-)
    # shellcheck disable=SC2034
    #local makeopts_mips64el=(ARCH=mips64 CROSS=mips64el-linux-musl-)
    for arch in x86_64 aarch64; do
        # shellcheck disable=SC1087
        eval "local opts=(\"\${makeopts_$arch[@]}\")"
        for target in all install; do
            # shellcheck disable=SC2154
            xmake "${opts[@]}" "$target"
        done
    done
}

build_i386() {
    local makeopts_i386=(prefix=/opt/diet32 MYARCH=i386)
    for target in all install; do
        xmake "${makeopts_i386[@]}" "$target"
    done
}

main() {
    local build_type="${1:-default}"
    cd "$HERE"
    mkdir -p "$TMP_DOWNLOAD"
    cp -a --reflink=auto . "$TMP_DOWNLOAD"
    cd "$TMP_DOWNLOAD"
    download_and_extract "$SRC_URL" "$SRC_DIR" "$TMP_BUILD"
    local patch_url="https://salsa.debian.org/debian/dietlibc/-/raw/db88cb7b9063d03284881e86a3101f58f764390d/debian/patches/bugfixes/newer-linux-headers.diff"
    local patch_dest="$TMP_DOWNLOAD/$(basename "$patch_url")"
    download "$patch_url" "$patch_dest"
    pushd "$TMP_BUILD" > /dev/null
    patch -p 1 -i "$patch_dest"
    "build_$build_type"
    popd > /dev/null
    rm -r "$TMP_BUILD" "$TMP_DOWNLOAD"
    eval "exit 0"
}

main "$@"
