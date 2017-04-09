FROM alpine:3.5
LABEL maintainer "Antoine Mary <antoinee.mary@gmail.com>"

### SET ENVIRONNEMENT
ENV LANG="en_US.UTF-8" \
    SOFTETHER_VERSION="v4.22-9634-beta"

### SETUP
COPY assets /assets
RUN apk update && apk upgrade && \
    apk add wget tar ca-certificates gcc make libc-dev libpthread-stubs openssl-dev readline-dev ncurses-dev && \
    update-ca-certificates && \
    addgroup softether && adduser -g 'softether' -G softether -s /sbin/nologin -D -H softether && \
    mv /assets/entrypoint.sh / && chmod +x /entrypoint.sh && \

    # Fetch sources
    wget -O - https://github.com/SoftEtherVPN/SoftEtherVPN/archive/${SOFTETHER_VERSION}.tar.gz | tar xzf - && \
    cd SoftEtherVPN-${SOFTETHER_VERSION:1} && \
    # Patching sources
    for file in /assets/patchs/*.sh; do /bin/sh "$file"; done && \
    # Compile and Install
    cp src/makefiles/linux_64bit.mak Makefile && \
    make && make install && \

    # Cleanning
    make clean && \
    cd .. && rm -rf SoftEtherVPN-${SOFTETHER_VERSION:1} && \
    apk del wget tar ca-certificates gcc make libc-dev libpthread-stubs openssl-dev readline-dev ncurses-dev && \
    rm -rf /var/cache/apk/* /assets

ENTRYPOINT ["/entrypoint.sh"]
CMD ["vpnserver start"]
