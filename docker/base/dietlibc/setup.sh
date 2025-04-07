#!/usr/bin/env bash
set -euo pipefail

HERE="$(dirname "$(readlink -f -- "$0")")"
JOBS="$(nproc)"

TMP_BUILD="/tmp/dietlibc_build"
TMP_DOWNLOAD="/tmp/dietlibc_download"

NAME="dietlibc"
VERSION="0.35"

SRC_DIR="$NAME-$VERSION"
SRC_FILENAME="$SRC_DIR.tar.xz"
SRC_URL="https://www.fefe.de/$NAME/$SRC_FILENAME"

MAKEOPTS=(-j "$JOBS")

download_and_extract() {
    url="$1"
    src="$2"
    dest="$3"
    url_file="$(basename "$1")"

    echo "$url"

    if ! [[ -f "$url_file" ]]; then
        echo "  downloading"
        wget -q "$url" -O "$url_file"
    else
        echo "  skipping download"
    fi

    if ! [[ -f "$url_file.skip_check" ]]; then
        printf "  verifying: "
        sha256sum -c "$url_file.sha256"
    else
        echo "  skipping verification"
    fi

    tmpd="$(mktemp -d)"
    pushd "$tmpd" > /dev/null
    echo "  extracting"
    tar xf "$TMP_DOWNLOAD/$url_file"
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
    local makeopts_i386=(prefix=/opt/diet32 MYARCH=i386 CFLAGS="-pipe -D_REENTRANT -ffreestanding")
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
    pushd "$TMP_BUILD" > /dev/null
    patch -p 1 -i "$HERE/newer-linux-headers.diff"
    pushd i386 > /dev/null
    patch -i "$HERE/i386-add_missing_syscall.patch"
    popd > /dev/null
    "build_$build_type"
    popd > /dev/null
    rm -r "$TMP_BUILD" "$TMP_DOWNLOAD"
    eval "exit 0"
}

main "$@"
