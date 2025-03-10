#!/usr/bin/env bash
set -euo pipefail

HERE="$(dirname "$(readlink -f -- "$0")")"

. "$HERE/../../repo.sh"

TAG_NAME="dmsetup-build"

# shellcheck source=../../scripts/build_in_docker.sh
. "$SCRIPTS_DIR/build_in_docker.sh"

main "$@"
