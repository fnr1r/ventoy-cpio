#!/usr/bin/env bash
set -euo pipefail

HERE="$(dirname "$(readlink -f -- "$0")")"

. "$HERE/../repo.sh"

JOBS="$(nproc)"

main() {
    make -j "$JOBS"
    eval "exit 0"
}

main "$@"
