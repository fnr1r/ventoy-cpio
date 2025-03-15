#!/usr/bin/env bash
set -euo pipefail

HERE="$(dirname "$(readlink -f -- "$0")")"

. "$HERE/../../repo.sh"
# shellcheck source=../../scripts/tool_build.sh
. "$SCRIPTS_DIR/tool_build.sh"

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
    CC=""
    MAKEBIN=("${@:2}")
    MAKEOPTS=()

    case $ARCH in
        aarch64)
            CC="diet aarch64-linux-gnu-gcc"
            ;;
        i386)
            CC="diet gcc -m32"
            ;;
        mips64el)
            CC="diet mips64el-linux-musl-gcc"
            ;;
        x86_64)
            CC="diet gcc"
            ;;
        *)
            exit 69
            ;;
    esac

    MAKEOPTS+=(
        "CC=$CC"
    )

    cd "$HERE"
    TMP_DIR="$(mktemp -d)"

    cp -ar src/. "$TMP_DIR"

    pushd "$TMP_DIR/programs" > /dev/null

    MAKE=("${MAKEBIN[@]}" "${MAKEOPTS[@]}")

    TARGET_BIN="zstd"

    "${MAKE[@]}" "$TARGET_BIN"

    mkdir -p "$DIST_DIR"
    #cp -ar "$TARGET_BIN" "$DIST_DIR/dmsetup.debug"
    #"${STRIP_CMD[@]}" "$TARGET_BIN"
    mv "$TARGET_BIN" "$DIST_DIR/zstdcat"

    popd > /dev/null
    rm -r "$TMP_DIR"

    eval "exit 0"
}

main "$@"
