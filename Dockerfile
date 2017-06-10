FROM alpine:3.6
LABEL maintainer="Antoine Mary <antoinee.mary@gmail.com>" \
      contributor="Dimitri G. <dev@dmgnx.net>"

### SET ENVIRONNEMENT
ENV LANG="en_US.UTF-8" \
    SOFTETHER_VERSION="v4.22-9634-beta"

### SETUP
COPY assets /assets
RUN set -ex ; \
    addgroup -S softether ; adduser -D -H softether -g softether -G softether -s /sbin/nologin ; \
    apk add --no-cache --virtual .build-deps \
      gcc make musl-dev ncurses-dev openssl-dev readline-dev wget ; \
    mv /assets/entrypoint.sh / ; chmod +x /entrypoint.sh ; \

    # Fetch sources
    wget --no-check-certificate -O - https://github.com/SoftEtherVPN/SoftEtherVPN/archive/${SOFTETHER_VERSION}.tar.gz | tar xzf - ; \
    cd SoftEtherVPN-${SOFTETHER_VERSION:1} ; \
    # Patching sources
    for file in /assets/patchs/*.sh; do /bin/sh "$file"; done ; \
    # Compile and Install
    cp src/makefiles/linux_64bit.mak Makefile ; \
    make ; make install ; make clean ; \
    # Striping vpnserver
    strip /usr/vpnserver/vpnserver ; \
    mkdir -p /etc/vpnserver /var/log/vpnserver; ln -s /etc/vpnserver/vpn_server.config /usr/vpnserver/vpn_server.config ; \

    # Cleanning
    apk del .build-deps ; \
    # Reintroduce necessary libraries
    apk add --no-cache --virtual .run-deps \
      libcap libcrypto1.0 libssl1.0 ncurses-libs readline su-exec ; \
    # Removing vpnbridge, vpnclient, vpncmd and build files
    cd .. ; rm -rf /usr/vpnbridge /usr/bin/vpnbridge /usr/vpnclient /usr/bin/vpnclient /usr/vpncmd /usr/bin/vpncmd /usr/bin/vpnserver \
      /assets SoftEtherVPN-${SOFTETHER_VERSION:1} ;

EXPOSE 443/tcp 992/tcp 1194/udp 5555/tcp

VOLUME ["/etc/vpnserver", "/var/log/vpnserver"]

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/vpnserver/vpnserver", "execsvc"]
