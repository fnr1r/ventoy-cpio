#!/usr/bin/env bash
#HERE="$(dirname "$(readlink -f -- "$0")")"

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

main() {
    no_rpl_malloc
    if [ "$WITH_DIETLIBC" = "yes" ]; then
        add_uint_defines
    fi
}

_entry() {
    set -euo pipefail
    main "$@"
    eval "exit $?"
}

_entry "$@"
