#!/bin/sh
set -e

if [ "x$1" = 'x/usr/vpnserver/vpnserver' ]; then
    for d in server_log security_log packet_log;
    do
        mkdir -p /var/log/vpnserver/$d
        ln -s /var/log/vpnserver/$d /usr/vpnserver/$d
    done
    chown -R softether:softether /usr/vpnserver
    setcap 'cap_net_bind_service=+ep' /usr/vpnserver/vpnserver

    echo "Starting SoftEther VPN Server"
    exec su-exec softether sh -c "`echo $@`"
else
    exec "$@"
fi
