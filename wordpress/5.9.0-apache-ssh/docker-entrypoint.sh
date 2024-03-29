#!/usr/bin/env bash

set -ex

FILE_INITIALIZED=/etc/docker-initialized

initial_setup() {
    if [ -z "$SSH_ROOT_PASSWORD" ]; then
        echo >&2 "error: SSH_ROOT_PASSWORD is not set"
        exit 1
    fi

    echo "root:$SSH_ROOT_PASSWORD" | chpasswd


    touch "$FILE_INITIALIZED"
}

if test ! -f "$FILE_INITIALIZED"; then
    initial_setup # setup root password
fi

/usr/sbin/sshd # start ssh server, default daemon mode

/usr/local/bin/docker-entrypoint.sh "$@"
