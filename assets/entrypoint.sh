#!/bin/sh
set -e

if [ "$1" = 'vpnserver' ]; then
    chown -R softether /usr/vpnserver
    echo "Starting SoftEther VPN Server"
    exec su-exec softether "$@"
    echo "Starting SoftEther VPN Started"
else
    exec "$@"
fi
