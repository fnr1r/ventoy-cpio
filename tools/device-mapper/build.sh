#!/usr/bin/env bash
set -euo pipefail

HERE="$(dirname "$(readlink -f -- "$0")")"

. "$HERE/../../scripts/tool_build.sh"

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

main() {
    ARCH="$1"
    DIST_DIR="$HERE/dist/$ARCH"
    MAKEBIN=("${@:2}")
    MAKEOPTS=()

    CONFIGURE_OPTS=()

    case $ARCH in
        aarch64)
            CC="diet aarch64-linux-gnu-gcc"
            CONFIGURE_OPTS=(--target=arm --host=x86_64-linux-gnu)
            STRIP_CMD=(aarch64-linux-gnu-strip)
            ;;
        i386)
            CC="diet gcc -m32"
            STRIP_CMD=(strip)
            ;;
        mips64el)
            echo broken ":("
            exit 69
            ;;
        x86_64)
            CC="diet gcc"
            STRIP_CMD=(strip --strip-all)
            ;;
        *)
            exit 69
            ;;
    esac

    cd "$HERE"
    TMP_DIR="$(mktemp -d)"

    cp -ar src/. "$TMP_DIR"

    pushd "$TMP_DIR" > /dev/null

    MAKE=("${MAKEBIN[@]}" "${MAKEOPTS[@]}")

    ./configure CC="$CC" \
        "${CONFIGURE_OPTS[@]}" \
        --disable-nls --disable-selinux --disable-shared
    no_rpl_malloc
    add_uint_defines
    patch_builtin_fs
    "${MAKE[@]}"
    unpatch_builtin_fs

    TARGET_BIN="dmsetup/dmsetup"

    mkdir -p "$DIST_DIR"
    cp -ar "$TARGET_BIN" "$DIST_DIR/dmsetup.debug"
    "${STRIP_CMD[@]}" "$TARGET_BIN"
    mv "$TARGET_BIN" "$DIST_DIR/dmsetup"

    popd > /dev/null
    rm -r "$TMP_DIR"

    eval "exit 0"
}

main "$@"
