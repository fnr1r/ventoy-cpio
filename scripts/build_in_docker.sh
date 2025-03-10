#!/usr/bin/env bash

docker_brun() {
    docker build -t "$1" docker
    docker run -it --rm \
        -v "$HERE":/build \
        "$1" \
        "${@:2}"
}

main() {
    docker_brun "$TAG_NAME" "$@"
    eval "exit 0"
}
