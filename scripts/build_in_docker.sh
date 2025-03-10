#!/usr/bin/env bash

if [[ -z "${REPO_DIR:-}" ]]; then
    echo "REPO_DIR not defined" > /dev/stderr
    exit 1
fi

docker_brun() {
    docker build -t "$1" docker
    docker run -it --rm \
        -v "$REPO_DIR":/build \
        "$1" \
        "${@:2}"
}

main() {
    docker_brun "$TAG_NAME" "$@"
    eval "exit 0"
}
