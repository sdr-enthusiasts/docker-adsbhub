FROM ghcr.io/sdr-enthusiasts/docker-baseimage:base

ENV SBSPORT=30003 \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

COPY rootfs/ /

RUN set -x && \
    chown root /usr/bin/adsbhub.sh && \
    chmod 755 /usr/bin/adsbhub.sh
# Add healthcheck
HEALTHCHECK --start-period=3600s --interval=600s CMD /scripts/healthcheck.sh
