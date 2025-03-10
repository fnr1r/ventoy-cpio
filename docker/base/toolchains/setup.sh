#!/usr/bin/env bash
set -euo pipefail

HERE="$(dirname "$(readlink -f -- "$0")")"

TOOLCHAINS=(
    "https://github.com/ventoy/vtoytoolchain/releases/download/1.0/gcc-linaro-7.4.1-2019.02-x86_64_aarch64-linux-gnu.tar.xz#gcc-linaro-7.4.1-2019.02-x86_64_aarch64-linux-gnu#gcc-linaro-7.4.1-2019.02-x86_64_aarch64-linux-gnu"
    "https://github.com/ventoy/vtoytoolchain/releases/download/1.0/mips-loongson-gcc7.3-2019.06-29-linux-gnu.tar.gz#mips-loongson-gcc7.3-linux-gnu/2019.06-29#mips-loongson-gcc7.3-2019.06-29-linux-gnu"
    #https://github.com/ventoy/vtoytoolchain/releases/download/1.0/aarch64--uclibc--stable-2020.08-1.tar.bz2
)

download_and_extract() {
    url="$1"
    src="$2"
    dest="$3"
    url_file="$(basename "$url")"

    echo "$url"

    if ! [[ -f "$url_file" ]]; then
        echo "  downloading"
        wget -q "$url"
    else
        echo "  skipping download"
    fi

    tmpd="$(mktemp -d)"
    pushd "$tmpd" > /dev/null
    echo "  extracting"
    tar -xf "$HERE/$url_file"
    mv "$src" "/opt/$dest"
    echo "  done"
    popd > /dev/null
    rm -r "$tmpd"
}

link_bins() {
    for bin in "$1"/bin/*; do
        bin_name="$(basename "$bin")"
        ln -s "$bin" /usr/local/bin/"$bin_name"
    done
}

main() {
    cd "$HERE"
    for i in "${TOOLCHAINS[@]}"; do
        IFS='#' read -r url src dest <<< "$i"
        download_and_extract "$url" "$src" "$dest"
    done
    for i in /opt/*; do
        link_bins "$i"
    done
    eval "exit 0"
}

main "$@"
