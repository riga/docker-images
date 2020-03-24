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

    push_images() {
        local image="$1"
        for version in "${@:2}"; do
            docker push "$user/$image:$version"
        done
    }

    # python images
    for image in py-base py-sci py-ml; do
        build_image "$image" "2.7" "$user"
        docker tag "$user/$image:2.7" "$user/$image:2"
        [ "$nopush" != "1" ] && push_images "$image" 2.7 2

        build_image "$image" "3.7" "$user"
        [ "$nopush" != "1" ] && push_images "$image" 3.7

        build_image "$image" "3.8" "$user"
        docker tag "$user/$image:3.8" "$user/$image:3"
        docker tag "$user/$image:3.8" "$user/$image:latest"
        [ "$nopush" != "1" ] && push_images "$image" 3.8 3 latest
    done
}
[ -z "$ZSH_VERSION" ] && export -f build_all
