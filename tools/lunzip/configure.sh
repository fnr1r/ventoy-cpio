#!/usr/bin/env bash
#HERE="$(dirname "$(readlink -f -- "$0")")"

main() {
    ./configure --disable-nls \
        CC="$CC" CPPFLAGS="-Wall -W" CFLAGS="$CFLAGS" LDFLAGS="$LDFLAGS"
}

_entry() {
    set -euo pipefail
    main "$@"
    eval "exit $?"
}

_entry "$@"
