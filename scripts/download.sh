#!/usr/bin/env bash
CURL_FLAGS=(-L -s)
WGET_FLAGS=(-q)

HASH_ALG_MAP=(
    .sha256:sha256sum
    .sha512:sha512sum
    .md5:md5sum
)

URL=""
TARGET_FILENAME=""

eecho() {
    echo "$@" > /dev/stderr
}

has_command() {
    which "$@" > /dev/null
}

download_with_curl() {
    curl "${CURL_FLAGS[@]}" -o "$TARGET_FILENAME" "$URL"
}

download_with_wget() {
    wget "${WGET_FLAGS[@]}" -O "$TARGET_FILENAME" "$URL"
}

try_download() {
    if has_command wget; then
        download_with_wget
    elif has_command curl; then
        download_with_curl
    else
        return 1
    fi
}

try_hash_check() {
    local suffix cmd
    for i in "${HASH_ALG_MAP[@]}"; do
        IFS=':' read -r suffix cmd <<< "$i"
        if [ -f "$TARGET_FILENAME$suffix" ]; then
            break
        fi
        suffix=""
    done
    if [ "$suffix" = "" ]; then
        eecho "Warning: No hash file for $TARGET_FILENAME"
        return
    fi

    local hashfile="$TARGET_FILENAME$suffix"
    if "$cmd" -c "$hashfile" > /dev/null; then
        return
    fi
    set +e
    rm "$TARGET_FILE"
    eecho "ERROR! HASH MISMATCH FOR $TARGET_FILENAME"
    cat "$hashfile"
    eecho "    !=    "
    "$cmd" "$TARGET_FILENAME" > /dev/stderr
    return 1
}

main() {
    URL="$1"
    TARGET_FILENAME="${2:-"$(basename "$URL")"}"
    if ! [ -f "$TARGET_FILENAME" ]; then
        try_download
    else
        eecho "Not redownloading $URL"
        eecho "Note: this should be handled by make"
    fi
    try_hash_check
}

_entry() {
    set -euo pipefail
    main "$@"
    eval "exit $?"
}

_entry "$@"
