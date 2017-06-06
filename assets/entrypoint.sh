#!/bin/sh
set -e

if [ "x$1" = 'x/usr/vpnserver/vpnserver' ]; then
    if [ -f /etc/vpnserver/vpn_server.config ]; then
        ln -s /etc/vpnserver/vpn_server.config /usr/vpnserver/vpn_server.config
    fi
    if [ -d /var/log/vpnserver ]; then
        mkdir -p /var/log/vpnserver/vpn_server/server_log
        mkdir -p /var/log/vpnserver/vpn_server/security_log
        mkdir -p /var/log/vpnserver/vpn_server/packet_log
        ln -s /var/log/vpnserver/vpn_server/server_log /usr/vpnserver/server_log
        ln -s /var/log/vpnserver/vpn_server/security_log /usr/vpnserver/security_log
        ln -s /var/log/vpnserver/vpn_server/packet_log /usr/vpnserver/packet_log
    fi
    chown -R softether:softether /usr/vpnserver
    setcap 'cap_net_bind_service=+ep' /usr/vpnserver/vpnserver

    echo "Starting SoftEther VPN Server"
    exec su-exec softether sh -c "`echo $@`"
else
    exec "$@"
fi
