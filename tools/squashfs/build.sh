#!/usr/bin/env bash
set -euo pipefail

HERE="$(dirname "$(readlink -f -- "$0")")"

. "$HERE/../../repo.sh"
# shellcheck source=../../scripts/tool_build.sh
. "$SCRIPTS_DIR/tool_build.sh"

ARCH=""
DIST_DIR=""
CC=""
CFLAGS=""
MAKEBIN=()
MAKEOPTS=()
STRIP_CMD=()

argparse() {
    ARCH="$1"
    DIST_DIR="$HERE/dist/$ARCH"
    MAKEBIN=("${@:2}")
    MAKEOPTS=(
        GZIP_SUPPORT=1
        XZ_SUPPORT=1
        LZO_SUPPORT=1
        LZ4_SUPPORT=1
        ZSTD_SUPPORT=1
        LZMA_XZ_SUPPORT=1
    )
    CFLAGS="-Os -flto"
    LDFLAGS="-static"

    case $ARCH in
        aarch64)
            exit 69
            #CC="aarch64-linux-gnu-gcc"
            #STRIP_CMD=(aarch64-linux-gnu-strip)
            ;;
        i386)
            CFLAGS+=" -m32"
            STRIP_CMD=(strip)
            ;;
        mips64el)
            exit 69
            #CC="mips64el-linux-musl-gcc"
            #STRIP_CMD=(mips64el-linux-musl-strip)
            #MAKEOPTS+=(
            #    "CC=$CC"
            #)
            ;;
        x86_64)
            MAKEOPTS+=(
                #"CC=musl-gcc"
            )
            STRIP_CMD=(strip --strip-all)
            ;;
        *)
            exit 69
            ;;
    esac
    MAKEOPTS+=(
        "CFLAGS=$CFLAGS"
        "LDFLAGS=$LDFLAGS"
    )
}

copysrc() {
    cp -ar src/. "$TMP_DIR"
}

TARGET_BIN="unsquashfs"

build() {
    PREFIX="$(pwd)/prefix"
    MAKEOPTS+=(
        #"CFLAGS="
        "INCLUDEDIR+=$PREFIX/include"
        "LDFLAGS+=$PREFIX/lib"
    )

    pushd lz4 > /dev/null
    "${MAKEBIN[@]}" -C lib "PREFIX=$PREFIX" install
    popd > /dev/null

    pushd lzo > /dev/null
    ./configure "--prefix=$PREFIX"
    "${MAKEBIN[@]}" install
    popd > /dev/null

    pushd xz > /dev/null
    popd > /dev/null

    pushd zstd > /dev/null
    "${MAKEBIN[@]}" -C lib "PREFIX=$PREFIX" install
    popd > /dev/null

    #pushd "squashfs-tools" > /dev/null
    cd squashfs-tools
    #MAKE=("${MAKEBIN[@]}" "${MAKEOPTS[@]}")
    env "${MAKEOPTS[@]}" "${MAKEBIN[@]}" \
        "$TARGET_BIN"
    #popd > /dev/null
}

package() {
    mkdir -p "$DIST_DIR"
    cp -ar "$TARGET_BIN" "$DIST_DIR/$TARGET_BIN.debug"
    "${STRIP_CMD[@]}" "$TARGET_BIN"
    cp -ar "$TARGET_BIN" "$DIST_DIR/$TARGET_BIN.stripped"
    upx "$TARGET_BIN"
    mv "$TARGET_BIN" "$DIST_DIR/$TARGET_BIN"
}

main "$@"
