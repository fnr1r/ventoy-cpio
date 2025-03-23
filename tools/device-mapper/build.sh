#!/usr/bin/env bash
set -euo pipefail

HERE="$(dirname "$(readlink -f -- "$0")")"

. "$HERE/../../repo.sh"
# shellcheck source=../../scripts/tool_build.sh
. "$SCRIPTS_DIR/tool_build.sh"

ARCH=""
CC=""
CFLAGS=""
MAKEBIN=()
MAKEOPTS=()

no_rpl_malloc() {
    sed -i include/configure.h \
        -e 's/^\#define malloc rpl_malloc/\/\/#define malloc rpl_malloc/'
}

add_uint_defines() {
    cat >> include/configure.h << EOF

#ifndef UINT32_MAX
#define UINT32_MAX  (4294967295U)
#endif

#ifndef UINT64_C
#define UINT64_C(c) c ## ULL
#endif
EOF
}

argparse() {
    ARCH="$1"
    CONFIGURE_OPTS=()
    MAKEBIN=("${@:2}")
    MAKEOPTS=()

    CFLAGS="-I$HERE/include"

    case $ARCH in
        aarch64)
            CC="diet aarch64-linux-gcc"
            CFLAGS+=" -fPIC"
            CONFIGURE_OPTS=(--host=arm-linux)
            STRIP_CMD=(aarch64-linux-strip)
            ;;
        i386)
            CC="diet gcc"
            CFLAGS+=" -m32"
            CONFIGURE_OPTS=(--host=i386-linux)
            STRIP_CMD=(strip)
            ;;
        mips64el)
            CC="diet mips64el-linux-musl-gcc"
            CONFIGURE_OPTS=(--host=mips64el-linux)
            STRIP_CMD=(mips64el-linux-musl-strip)
            ;;
        x86_64)
            CC="diet gcc"
            CFLAGS+=" -fPIC"
            STRIP_CMD=(strip --strip-all)
            ;;
        *)
            exit 69
            ;;
    esac

    BUILD_SUB_DIR="$ARCH"
    TARGET_SUB_DIR="$ARCH"
}

copysrc() {
    cp -ar --reflink=auto src/. "$WORK_DIR"
}

prepare() {
    ./configure --disable-nls --disable-selinux \
        --disable-shared --enable-static_link \
        "${CONFIGURE_OPTS[@]}" "CC=$CC"
    no_rpl_malloc
    add_uint_defines
}

BIN_NAME="dmsetup"

build() {
    MAKE=("${MAKEBIN[@]}" "${MAKEOPTS[@]}")
    "${MAKE[@]}" CFLAGS="$CFLAGS"
}

package() {
    TARGET_BIN="$BIN_NAME/$BIN_NAME.static"
    cp -ar "$TARGET_BIN" "$TARGET_DIR/$BIN_NAME.debug"
    "${STRIP_CMD[@]}" "$TARGET_BIN"
    mv "$TARGET_BIN" "$TARGET_DIR/$BIN_NAME"
}

main "$@"
