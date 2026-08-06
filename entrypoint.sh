#!/bin/sh

. /lib.subr

set -e

create_user

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
    set -- haproxy "$@"
fi

if [ "$1" = 'haproxy' ]; then
    shift # "haproxy"
    # If haproxy was started previously by service(8).
    if service haproxy status > /dev/null; then
        service haproxy onestop
    fi
    # if the user wants "haproxy", let's add a couple useful flags
    #   -W  -- "master-worker mode" (similar to the old "haproxy-systemd-wrapper"; allows for reload via "SIGUSR2")
    #   -db -- disables background mode
    set -- haproxy -W -db "$@"
elif [ "$1" = 'dataplaneapi' ]; then
    shift # "haproxy"
    change_owner /usr/local/etc/haproxy
    dasel put -f /usr/local/etc/haproxy/dataplaneapi.yaml -r yaml -t int -v "${PUID}" dataplaneapi.uid
    if ! service haproxy status > /dev/null; then
        sysrc haproxy_enable="YES"
        sysrc haproxy_config=/usr/local/etc/haproxy/haproxy.cfg
        service haproxy start
    fi
    set -- dataplaneapi -f=/usr/local/etc/haproxy/dataplaneapi.yaml "$@"
fi

exec "$@"
