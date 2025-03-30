#!/usr/bin/env bash
set -euo pipefail

HERE="$(dirname "$(readlink -f -- "$0")")"
JOBS="$(nproc)"

TMP_BUILD="/tmp/musl_build"
TMP_DOWNLOAD="/tmp/musl_download"

NAME="musl"
VERSION="1.2.1"

SRC_DIR="$NAME-$VERSION"
SRC_FILENAME="$SRC_DIR.tar.gz"
SRC_URL="https://musl.libc.org/releases/$SRC_FILENAME"

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
    exit 69
}

build_i386() {
    # apparently yes means optimize for size
    # go figure, it passes -Os
    ./configure --build=i386-linux-gnu \
        --prefix=/opt/musl-i386 --syslibdir=/ventoy/lib \
        --enable-optimize=yes --enable-debug=no --disable-shared
    xmake
    for target in all install; do
        xmake "$target"
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
    "build_$build_type"
    popd > /dev/null
    rm -r "$TMP_BUILD" "$TMP_DOWNLOAD"
    eval "exit 0"
}

main "$@"
