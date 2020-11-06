FROM debian:stable-slim

ENV BEASTPORT=30005 \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2

RUN set -x && \
   apt-get update && \
    apt-get install --no-install-recommends -y \
        bash \
        bc \
        ca-certificates \
        curl \
        file \
        libc6 \
        lsb-base \
        procps \
        wget \ 
        netcat \
        net-tools \
        socat \
        && \
     curl -s https://raw.githubusercontent.com/mikenye/deploy-s6-overlay/master/deploy-s6-overlay.sh | sh && \
    rm -rf /var/lib/apt/lists/* /src /tmp/*

COPY rootfs/ /

ENTRYPOINT [ "/init" ]

EXPOSE 5001/tcp

# Add healthcheck
HEALTHCHECK --start-period=300s --interval=300s  CMD /healthcheck.sh
