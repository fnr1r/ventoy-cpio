#!/usr/bin/env bash

SRCHERE="$(dirname "$(readlink -f -- "${BASH_SOURCE[0]}")")"

if [[ -z "${REPO_DIR:-}" ]]; then
    REPO_DIR="$(readlink -f -- "$SRCHERE")"
    readonly REPO_DIR
fi

if [[ -z "${SCRIPTS_DIR:-}" ]]; then
    SCRIPTS_DIR="$REPO_DIR/scripts"
    readonly SCRIPTS_DIR
fi
