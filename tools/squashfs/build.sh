#!/usr/bin/env bash
set -euo pipefail

HERE="$(dirname "$(readlink -f -- "$0")")"

. "$HERE/../../repo.sh"
# shellcheck source=../../scripts/tool_build.sh
. "$SCRIPTS_DIR/tool_build.sh"

ARCH=""
CC=""
CFLAGS=""
CONFIGURE_OPTS=()
MAKEBIN=()
MAKEOPTS=()
LDFLAGS=""
STRIP_CMD=()
Q_CFLAGS=""
Q_LDFLAGS=""

argparse() {
    ARCH="$1"
    MAKEBIN=("${@:2}")
    MAKEOPTS=(
        GZIP_SUPPORT=1
        XZ_SUPPORT=1
        LZO_SUPPORT=1
        LZ4_SUPPORT=1
        ZSTD_SUPPORT=1
        LZMA_XZ_SUPPORT=1
    )
    Q_CFLAGS="-Os -flto"
    Q_LDFLAGS="-static"

    case $ARCH in
        aarch64)
            CC="aarch64-linux-gnu-gcc"
            CONFIGURE_OPTS=(--host=arm-linux)
            STRIP_CMD=(aarch64-linux-gnu-strip)
            ;;
        i386)
            CC="gcc"
            CFLAGS="-m32"
            CONFIGURE_OPTS=(--host=i386-linux)
            LDFLAGS="-m32"
            STRIP_CMD=(strip)
            ;;
        mips64el)
            CC="mips64el-linux-musl-gcc"
            CONFIGURE_OPTS=(--host=mips64el-linux)
            STRIP_CMD=(mips64el-linux-musl-strip)
            ;;
        x86_64)
            CC="musl-gcc"
            STRIP_CMD=(strip --strip-all)
            ;;
        *)
            exit 69
            ;;
    esac

    #BUILD_SUB_DIR="$ARCH"
    TARGET_SUB_DIR="$ARCH"
}

copysrc() {
    cp -ar --reflink=auto src/. "$WORK_DIR"
}

TARGET_BIN="unsquashfs"

build() {
    PREFIX="$WORK_DIR/prefix"

    pushd lz4 > /dev/null
    CFLAGS="$CFLAGS" LDFLAGS="$LDFLAGS" "${MAKEBIN[@]}" "CC=$CC" -C lib "PREFIX=$PREFIX" "BUILD_SHARED=no" install
    popd > /dev/null

    pushd lzo > /dev/null
    #if ! [[ -f .configured ]]; then
        LZO_CFLAGS=""
        if [[ -n "$CFLAGS" ]]; then
            LZO_CFLAGS+=" $CFLAGS"
        fi
        ./configure \
            --prefix="$PREFIX" \
            "${CONFIGURE_OPTS[@]}" "CC=$CC" CFLAGS="$LZO_CFLAGS"
        #touch .configured
    #fi
    "${MAKEBIN[@]}" install
    popd > /dev/null

    pushd xz > /dev/null
    #if ! [[ -f .configured ]]; then
        XZ_CFLAGS=""
        if [[ -n "$CFLAGS" ]]; then
            XZ_CFLAGS+=" $CFLAGS"
        fi
        ./configure \
            --prefix="$PREFIX" \
            --enable-shared=no --enable-static=yes \
            --disable-xz --disable-xzdec \
            --disable-lzmadec --disable-lzmainfo --disable-lzma-links \
            --disable-scripts \
            --disable-assembler \
            "${CONFIGURE_OPTS[@]}" "CC=$CC" CFLAGS="$XZ_CFLAGS"
        #touch .configured
    #fi
    "${MAKEBIN[@]}" install
    popd > /dev/null

    pushd zlib > /dev/null
    #if ! [[ -f .configured ]]; then
        ZLIB_CFLAGS="-O3"
        if [[ -n "$CFLAGS" ]]; then
            ZLIB_CFLAGS=" $CFLAGS"
        fi
        CC="$CC" CFLAGS="$ZLIB_CFLAGS" ./configure \
            --prefix="$PREFIX" \
            --static
        #touch .configured
    #fi
    "${MAKEBIN[@]}" install
    popd > /dev/null

    pushd zstd > /dev/null
    CFLAGS="$CFLAGS $Q_CFLAGS" LDFLAGS="$LDFLAGS $Q_LDFLAGS" "${MAKEBIN[@]}" \
        "CC=$CC" "PREFIX=$PREFIX" -C lib \
        install-static install-includes
    popd > /dev/null

    #pushd "squashfs-tools" > /dev/null
    cd squashfs-tools
    #MAKE=("${MAKEBIN[@]}" "${MAKEOPTS[@]}")
    CFLAGS="$CFLAGS $Q_CFLAGS -I$PREFIX/include" LDFLAGS="$LDFLAGS $Q_LDFLAGS -L$PREFIX/lib" "${MAKEBIN[@]}" \
        "CC=$CC" "${MAKEOPTS[@]}" \
        "$TARGET_BIN"
    #popd > /dev/null
}

package() {
    cp -ar "$TARGET_BIN" "$TARGET_DIR/$TARGET_BIN.debug"
    "${STRIP_CMD[@]}" "$TARGET_BIN"
    if [[ "$ARCH" != "mips64el" ]] && [[ "$ARCH" != "x86_64" ]]; then
        cp -ar "$TARGET_BIN" "$TARGET_DIR/$TARGET_BIN.stripped"
        upx "$TARGET_BIN"
    fi
    mv "$TARGET_BIN" "$TARGET_DIR/$TARGET_BIN"
}

main "$@"
