#!/bin/bash

IMAGE=prom/prometheus

function do_build {
    docker pull ${IMAGE}
}

function do_init {
    if [ ! -d /usr/local/etc ]
    then
        mkdir /usr/local/etc
    fi
    sudo install -c -m 644 prometheus.yml /usr/local/etc/prometheus.yml
}

function do_restart {
    do_stop
    sleep 5
    do_start
}

function do_start {
    docker run \
        -d \
        -p 9099:9090 \
        -v /usr/local/etc/prometheus.yml:/etc/prometheus/prometheus.yml \
        --name prometheus \
        --restart unless-stopped \
        ${IMAGE}
}

function do_stop {
    docker rm -f prometheus
}

function do_shell {
    docker exec -it prometheus /bin/bash
}

function do_test {
    curl -G http://localhost:9099/targets
}

function do_update {
    do_stop
    sleep 5
    do_init
    do_start
}

task=$1
shift
do_$task $*
