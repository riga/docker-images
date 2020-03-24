#!/usr/bin/env bash

build_image() {
    local this_file="$( [ ! -z "$ZSH_VERSION" ] && echo "${(%):-%x}" || echo "${BASH_SOURCE[0]}" )"
    local this_dir="$( cd "$( dirname "$this_file" )" && pwd )"

    local image="$1"
    local version="$2"
    local user="${3:-riga}"

    local context_dir="$this_dir/$image"
    local docker_file="Dockerfile_$( echo "$version" | sed "s/\.//g" )"
    local tag="$user/$image:$version"

    if [ ! -d "$context_dir" ]; then
        2>&1 echo "unknown image '$image'"
        return "1"
    fi

    if [ ! -f "$context_dir/$docker_file" ]; then
        2>&1 echo "unknown version '$version' for image '$image'"
        return "2"
    fi

    (
        echo "building image $tag from $context_dir/$docker_file"
        cd "$context_dir"
        docker build --file "$docker_file" --tag "$tag" .
    )
}
[ -z "$ZSH_VERSION" ] && export -f build_image

build_all() {
    local user="${1:-riga}"
    local nopush="${2:-0}"

    # python images
    for version in 2.7 3.7 3.8; do
        for image in py-base py-sci py-ml; do
            build_image "$image" "$version" "$user"

            if [ "$nopush" != "1" ]; then
                docker push "$user/$image:$version"
            fi
        done
    done
}
[ -z "$ZSH_VERSION" ] && export -f build_all
