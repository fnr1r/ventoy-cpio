#!/usr/bin/env bash
set -euo pipefail

HERE="$(dirname "$(readlink -f -- "$0")")"

. "$HERE/../../repo.sh"
# shellcheck source=../../scripts/tool_build.sh
. "$SCRIPTS_DIR/tool_build.sh"

ARCH=""
BIN_NAME=""
CONFIG_NAME=""
MAKEBIN=()
MAKEOPTS=()
PROG=""

argparse() {
    BIN_NAME="$1"

    IFS=_ read -r arch prog prog2 <<< "$BIN_NAME"
    ARCH="${arch}"
    PROG="${prog}"

    CONFIG_NAME="$BIN_NAME.config"

    MAKEBIN=("${@:2}")
    MAKEOPTS=(
        "KBUILD_SRC=$HERE/src"
        -f "$HERE/src/Makefile"
    )

    case $arch in
        aarch64)
            MAKEOPTS+=(
                "ARCH=arm64"
                "CROSS_COMPILE=aarch64-linux-gnu-"
            )
            ;;
        i386)
            MAKEOPTS+=(
                #"CC=musl-gcc"
                #"LD=musl-ldd"
                #"LDFLAGS=-"
                "ARCH=i386"
                "CFLAGS+=-m32"
                "LDFLAGS+=-m32"
            )
            CONFIG_NAME="x86_64_${prog}.config"
            ;;
        mips64el)
            MAKEOPTS+=(
                "ARCH=mips"
                "CROSS_COMPILE=mips64el-linux-musl-"
                "CFLAGS+=-mips64r2 -mabi=64 -Os"
                "LDFLAGS+=-mips64r2 -mabi=64 -Os"
            )
            ;;
        x86)
            ARCH="${arch}_${prog}"
            PROG="${prog2}"
            if [[ "$PROG" != "busybox" ]]; then
                MAKEOPTS+=("CC=musl-gcc")
            fi
            ;;
        *)
            exit 69
            ;;
    esac
}

prepare() {
    MAKE=("${MAKEBIN[@]}" "${MAKEOPTS[@]}")
    if [[ "$PROG" == "busybox" ]]; then
        "${MAKE[@]}" defconfig > /dev/null
    else
        cp -a "$HERE/configs/$CONFIG_NAME" .config
    fi
}

build() {
    MAKE=("${MAKEBIN[@]}" "${MAKEOPTS[@]}")
    "${MAKE[@]}"
}

package() {
    target_path="$HERE/dist/$BIN_NAME"
    mv busybox "$target_path"
}

postbuild() {
    alt_target_dir="$HERE/dist/$ARCH"
    mkdir -p "$alt_target_dir"
    ln -s "../$BIN_NAME" "$alt_target_dir/$PROG"
}

main "$@"
