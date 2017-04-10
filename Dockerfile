FROM alpine:3.5
LABEL maintainer "Antoine Mary <antoinee.mary@gmail.com>"

### SET ENVIRONNEMENT
ENV LANG="en_US.UTF-8" \
    SOFTETHER_VERSION="v4.22-9634-beta"

### SETUP
COPY assets /assets
RUN apk update && apk upgrade && \
    apk add wget make gcc musl-dev readline-dev openssl-dev ncurses-dev su-exec && \
    addgroup softether && adduser -g 'softether' -G softether -s /sbin/nologin -D -H softether && \
    mv /assets/entrypoint.sh / && chmod +x /entrypoint.sh && \

    # Fetch sources
    wget --no-check-certificate -O - https://github.com/SoftEtherVPN/SoftEtherVPN/archive/${SOFTETHER_VERSION}.tar.gz | tar xzf - && \
    cd SoftEtherVPN-${SOFTETHER_VERSION:1} && \
    # Patching sources
    for file in /assets/patchs/*.sh; do /bin/sh "$file"; done && \
    # Compile and Install
    cp src/makefiles/linux_64bit.mak Makefile && \
    make && make install && make clean && \

    # Cleanning
    apk del wget make gcc musl-dev readline-dev openssl-dev ncurses-dev && \
    # Reintroduce necessary libraries
    apk add libssl1.0	libcrypto1.0 readline ncurses-libs && \
    # Removing vpnbridge, vpnclient , vpncmd and build files
    cd .. && rm -rf /usr/vpnbridge /usr/bin/vpnbridge /usr/vpnclient /usr/bin/vpnclient /usr/vpncmd /usr/bin/vpncmd \
    /var/cache/apk/* /assets SoftEtherVPN-${SOFTETHER_VERSION:1}

EXPOSE 443/tcp 992/tcp 1194/udp 5555/tcp

ENTRYPOINT ["/entrypoint.sh"]
CMD ["vpnserver", "execsvc"]
