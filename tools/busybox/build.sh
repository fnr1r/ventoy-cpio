#!/usr/bin/env bash
set -euo pipefail

HERE="$(dirname "$(readlink -f -- "$0")")"

. "$HERE/../../scripts/tool_build.sh"

main() {
    bin_name="$1"

    IFS=_ read -r arch prog prog2 <<< "$bin_name"

    config_name="$bin_name.config"

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
                "ARCH=i386"
                "CFLAGS+=-m32"
                "LDFLAGS+=-m32"
            )
            config_name="x86_64_${prog}.config"
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
            arch="${arch}_${prog}"
            prog="${prog2}"
            ;;
        *)
            exit 69
            ;;
    esac

    cd "$HERE"
    TMP_DIR="$(mktemp -d)"
    cd "$TMP_DIR"
    pushd "$TMP_DIR" > /dev/null

    MAKE=("${MAKEBIN[@]}" "${MAKEOPTS[@]}")

    if [[ "$prog" == "busybox" ]]; then
        "${MAKE[@]}" defconfig
    else
        cp -a "$HERE/configs/$config_name" .config
    fi
    "${MAKE[@]}"

    target_path="$HERE/dist/$bin_name"
    mv busybox "$target_path"

    popd > /dev/null
    rm -r "$TMP_DIR"

    alt_target_dir="$HERE/dist/$arch"
    mkdir -p "$alt_target_dir"
    ln -s "../$bin_name" "$alt_target_dir/$prog"

    eval "exit 0"
}

main "$@"
