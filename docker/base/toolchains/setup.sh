#!/usr/bin/env bash
set -euo pipefail

HERE="$(dirname "$(readlink -f -- "$0")")"

TMP_DOWNLOAD="/tmp/toolchains_download"

TOOLCHAINS=(
    "https://www.uclibc.org/downloads/binaries/0.9.30.1/mini-native-x86_64.tar.bz2#mini-native-x86_64#mini-native-x86_64"
    "https://github.com/ventoy/vtoytoolchain/releases/download/1.0/aarch64--uclibc--stable-2020.08-1.tar.bz2#aarch64--uclibc--stable-2020.08-1#aarch64--uclibc--stable-2020.08-1"
    #"https://github.com/ventoy/vtoytoolchain/releases/download/1.0/gcc-linaro-7.4.1-2019.02-x86_64_aarch64-linux-gnu.tar.xz#gcc-linaro-7.4.1-2019.02-x86_64_aarch64-linux-gnu#gcc-linaro-7.4.1-2019.02-x86_64_aarch64-linux-gnu"
    #"https://github.com/ventoy/vtoytoolchain/releases/download/1.0/mips-loongson-gcc7.3-2019.06-29-linux-gnu.tar.gz#mips-loongson-gcc7.3-linux-gnu/2019.06-29#mips-loongson-gcc7.3-2019.06-29-linux-gnu"
    "https://github.com/ventoy/musl-cross-make/releases/download/latest/output.tar.bz2#output#mips64el-linux-gnu-musl-gcc7.3.0"
)

download_and_extract() {
    url="$1"
    src="$2"
    dest="$3"
    url_file="$(basename "$url")"

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

#link_bins() {
#    for bin in "$1"/bin/*; do
#        bin_name="$(basename "$bin")"
#        ln -s "$bin" /usr/local/bin/"$bin_name"
#    done
#}

UCLIBC_PATH="/opt/mini-native-x86_64"
UCLIBC_BINS=(g++ ld rawgcc)

post_extract() {
    pushd "$UCLIBC_PATH" > /dev/null
    pushd usr/bin > /dev/null
    for bin in "${UCLIBC_BINS[@]}"; do
        patchelf --set-interpreter "$UCLIBC_PATH/usr/lib/ld-uClibc.so.0" "$bin"
    done
    popd > /dev/null
    pushd usr/libexec/gcc/x86_64-unknown-linux/4.1.2 > /dev/null
    for bin in *; do
        patchelf --set-interpreter "$UCLIBC_PATH/usr/lib/ld-uClibc.so.0" "$bin"
    done
    popd > /dev/null
    mkdir -p xbin
    cd xbin
    for bin in gcc ld; do
        cat > "$bin" <<EOF
#!/usr/bin/env bash
set -euo pipefail
IPATH="/opt/mini-native-x86_64"
NAME="\$(basename \$(readlink -f -- \$0))"
#LD_LIBRARY_PATH="\$IPATH/usr/lib"
exec "\$IPATH/usr/bin/\$NAME" "\$@"
EOF
        chmod +x "$bin"
    done
    popd > /dev/null
}

main() {
    cd "$HERE"
    mkdir -p "$TMP_DOWNLOAD"
    cp -a --reflink=auto . "$TMP_DOWNLOAD"
    cd "$TMP_DOWNLOAD"
    for i in "${TOOLCHAINS[@]}"; do
        IFS='#' read -r url src dest <<< "$i"
        download_and_extract "$url" "$src" "/opt/$dest"
    done
    #for i in /opt/*; do
    #    link_bins "$i"
    #done
    post_extract
    rm -r "$TMP_DOWNLOAD"
    eval "exit 0"
}

main "$@"
