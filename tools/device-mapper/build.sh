#!/usr/bin/env bash
set -euo pipefail

HERE="$(dirname "$(readlink -f -- "$0")")"

. "$HERE/../../repo.sh"
# shellcheck source=../../scripts/tool_build.sh
. "$SCRIPTS_DIR/tool_build.sh"

ARCH=""
CC=""
DIST_DIR=""
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

OS_INCLUDE="/usr/include"
FS_H="$OS_INCLUDE/linux/fs.h"

patch_builtin_fs() {
    if [[ -f "$FS_H.bak" ]]; then
        return
    fi
    sudo mv "$FS_H" "$FS_H.bak"
    echo '#include <sys/mount.h>' | sudo tee "$FS_H" > /dev/null
}

unpatch_builtin_fs() {
    if [[ -f "$FS_H.bak" ]]; then
        sudo rm "$FS_H"
        sudo mv "$FS_H.bak" "$FS_H"
    fi
}

argparse() {
    ARCH="$1"
    CONFIGURE_OPTS=()
    DIST_DIR="$HERE/dist/$ARCH"
    MAKEBIN=("${@:2}")
    MAKEOPTS=()

    case $ARCH in
        aarch64)
            CC="diet aarch64-linux-gnu-gcc"
            CONFIGURE_OPTS=(--target=arm --host=x86_64-linux-gnu)
            STRIP_CMD=(aarch64-linux-gnu-strip)
            ;;
        i386)
            CC="diet gcc"
            MAKEOPTS+=(
                "CFLAGS+=-m32"
            )
            STRIP_CMD=(strip)
            ;;
        mips64el)
            CC="diet mips64el-linux-musl-gcc"
            CONFIGURE_OPTS=(--target=mips64el --host=x86_64-linux-gnu)
            STRIP_CMD=(mips64el-linux-musl-strip)
            FS_H="/opt/mips64el-linux-gnu-musl-gcc7.3.0/mips64el-linux-musl/include/linux/fs.h"
            ;;
        x86_64)
            CC="diet gcc"
            STRIP_CMD=(strip --strip-all)
            ;;
        *)
            exit 69
            ;;
    esac
}

copysrc() {
    cp -ar src/. "$TMP_DIR"
}

prepare() {
    ./configure CC="$CC" \
        "${CONFIGURE_OPTS[@]}" \
        --disable-nls --disable-selinux --disable-shared
    no_rpl_malloc
    add_uint_defines
    patch_builtin_fs
}

build() {
    MAKE=("${MAKEBIN[@]}" "${MAKEOPTS[@]}")
    "${MAKE[@]}" dmsetup
    unpatch_builtin_fs
}

package() {
    TARGET_BIN="dmsetup/dmsetup"
    mkdir -p "$DIST_DIR"
    cp -ar "$TARGET_BIN" "$DIST_DIR/dmsetup.debug"
    "${STRIP_CMD[@]}" "$TARGET_BIN"
    mv "$TARGET_BIN" "$DIST_DIR/dmsetup"
}

main "$@"
