#!/usr/bin/env bash

action() {
    local user="riga"
    [ ! -z "$1" ] && user="$1"

    for d in py2-base py2-sci py3-base py3-sci; do
        docker build -t $user/$d $d
        docker push riga/$d
    done
}
action "$@"
