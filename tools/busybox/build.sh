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
                "CROSS_COMPILE=aarch64-linux-"
                "CFLAGS+=-Os"
            )
            ;;
        i386)
            MAKEOPTS+=(
                #"CC=musl-gcc"
                #"LD=musl-ldd"
                #"LDFLAGS=-"
                "ARCH=i386"
                "CFLAGS+=-m32 -Os"
                "LDFLAGS+=-m32 -Os"
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
            MAKEOPTS+=(
                "CC=musl-gcc"
                "CFLAGS+=-Os"
            )
            ;;
        *)
            exit 69
            ;;
    esac

    BUILD_SUB_DIR="$BIN_NAME"
    TARGET_SUB_DIR="$ARCH"
}

prepare() {
    local config=""
    case $PROG in
        ash)
            if [[ "$ARCH" == "aarch64" ]]; then
                config="$HERE/configs/04-ash-internal-glob.config"
            elif [[ "$ARCH" == "mips64el" ]]; then
                config="$HERE/configs/02-ash-only.config"
            else
                config="$HERE/configs/03-ash-extras.config"
            fi
            ;;
        busybox)
            config="$HERE/configs/01-defconfig-static.config"
            ;;
        hexdump)
            config="$HERE/configs/03-hexdump.config"
            ;;
        xzcat)
            config="$HERE/configs/03-xzcat-only.config"
            ;;
        *)
            exit 69
            ;;
    esac
    if [[ -z "$config" ]]; then
        exit 69
    fi
    cp -aL "$config" .config
}

build() {
    MAKE=("${MAKEBIN[@]}" "${MAKEOPTS[@]}")
    "${MAKE[@]}"
}

package() {
    mv busybox "$HERE/dist/$BIN_NAME"
}

postbuild() {
    ln -s "../$BIN_NAME" "$TARGET_DIR/$PROG"
}

main "$@"
