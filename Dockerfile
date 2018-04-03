FROM alpine:3.7 as build
### SET ENVIRONNEMENT
ENV LANG="en_US.UTF-8" \
    SOFTETHER_VERSION="5.1"

### SETUP
RUN apk add --no-cache --virtual .build-deps \
      gcc make musl-dev ncurses-dev openssl-dev readline-dev wget

COPY patchs /patchs
# Fetch sources
RUN wget --no-check-certificate -O - https://github.com/SoftEtherVPN/SoftEtherVPN/archive/${SOFTETHER_VERSION}.tar.gz | tar xzf -

WORKDIR /SoftEtherVPN-${SOFTETHER_VERSION}

# Patching sources
RUN for file in /patchs/*.sh; do /bin/sh "$file"; done ;
# Compile and Install
RUN cp src/makefiles/linux_64bit.mak Makefile
RUN make ; make install ; make clean
# Striping vpnserver
RUN strip /usr/vpnserver/vpnserver

##################

FROM amary/base:3.7
LABEL maintainer="Antoine Mary <antoinee.mary@gmail.com>" \
      contributor="Dimitri G. <dev@dmgnx.net>"

ENV LANG="en_US.UTF-8" \
    APP_NAME="SoftEtherVPN Server" \
    APP_VERSION="5.1" \
    APP_LOCATION="/usr/vpnserver/vpnserver"

### SETUP
RUN apk add --no-cache --virtual .run-deps \
      libcap libcrypto1.0 libssl1.0 ncurses-libs readline

COPY --from=build --chown=app:app /usr/vpnserver /usr/vpnserver

EXPOSE 443/tcp 992/tcp 1194/udp 5555/tcp

STOPSIGNAL SIGINT
VOLUME ["/etc/vpnserver", "/var/log/vpnserver"]
CMD ["/usr/vpnserver/vpnserver", "execsvc"]
