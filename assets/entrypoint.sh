#!/bin/sh
set -e

if [ "$1" = '/usr/vpnserver/vpnserver' ]; then
    chown -R softether:softether /usr/vpnserver
    setcap 'cap_net_bind_service=+ep' /usr/vpnserver/vpnserver

    echo "Starting SoftEther VPN Server"
    exec su-exec softether sh -c "`echo $@`"
else
    exec "$@"
fi
