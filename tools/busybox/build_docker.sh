#!/usr/bin/env bash
set -euo pipefail

HERE="$(dirname "$(readlink -f -- "$0")")"

TAG_NAME="busybox-build"

. "$HERE/../../scripts/build_in_docker.sh"

main "$@"
