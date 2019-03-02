#!/usr/bin/env bash

build_py() {
    local image="$1"
    local version="$2"
    local nopush="$3"

    if [ "$image" != "base" ] && [ "$image" != "sci" ]; then
        2&>1 echo "unknown image '$image'"
        return "1"
    fi

    if [ "$version" = "2" ]; then
        docker build -t riga/py-$image:2.7 py-$image-27
        docker tag riga/py-$image:2.7 riga/py-$image:2
        if [ "$nopush" != "1" ]; then
            docker push riga/py-$image:2.7
            docker push riga/py-$image:2
        fi
    elif [ "$version" = "3" ]; then
        docker build -t riga/py-$image:3.7 py-$image-37
        docker tag riga/py-$image:3.7 riga/py-$image:3
        docker tag riga/py-$image:3.7 riga/py-$image:latest
        if [ "$nopush" != "1" ]; then
            docker push riga/py-$image:3.7
            docker push riga/py-$image:3
            docker push riga/py-$image:latest
        fi
    else
        2&>1 echo "unknown version '$version'"
        return "1"
    fi
}

export -f build_py
