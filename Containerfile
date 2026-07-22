ARG FREEBSD_RELEASE

FROM ghcr.io/appjail-makejails/core:${FREEBSD_RELEASE}

ARG NO_PKGCLEAN
ARG HAPROXYVER

LABEL org.opencontainers.image.title="HAProxy" \
    org.opencontainers.image.description="Reliable, high performance TCP/HTTP load balancer" \
    org.opencontainers.image.source="https://github.com/AppJail-makejails/haproxy" \
    org.opencontainers.image.url="https://github.com/AppJail-makejails/haproxy" \
    org.opencontainers.image.vendor="DtxdF" \
    org.opencontainers.image.authors="Jesús Daniel Colmenares Oviedo <dtxdf@disroot.org>"

RUN set -xe; \
    \
    pkg update; \
    pkg install -U haproxy${HAPROXYVER}; \
    \
    if [ -z "${NO_PKGCLEAN}" ]; then \
        pkg clean -a; \
        rm -rf /var/cache/pkg/*; \
    fi; \
    rm -rf /var/db/pkg/repos/*

COPY entrypoint.sh /

RUN chmod +x /entrypoint.sh && \
    mkdir -p /usr/local/etc/haproxy

COPY haproxy.cfg /usr/local/etc/haproxy

STOPSIGNAL SIGUSR1

ENTRYPOINT ["/entrypoint.sh"]
CMD ["haproxy", "-f", "/usr/local/etc/haproxy/haproxy.cfg"]
