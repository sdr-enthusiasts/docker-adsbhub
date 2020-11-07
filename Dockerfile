FROM debian:stable-slim

ENV BEASTPORT=30005 \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN set -x && \
    TEMP_PACKAGES=() && \
    KEPT_PACKAGES=() && \
    KEPT_PACKAGES+=(ca-certificates) && \
    KEPT_PACKAGES+=(wget) && \
    KEPT_PACKAGES+=(net-tools) && \
    KEPT_PACKAGES+=(socat) && \
    TEMP_PACKAGES+=(gnupg) && \
    TEMP_PACKAGES+=(file) && \
    TEMP_PACKAGES+=(curl) && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        ${KEPT_PACKAGES[@]} \
        ${TEMP_PACKAGES[@]} \
        && \
    curl -s https://raw.githubusercontent.com/mikenye/deploy-s6-overlay/master/deploy-s6-overlay.sh | sh && \
    apt-get remove -y ${TEMP_PACKAGES[@]} && \
    apt-get autoremove -y && \
    rm -rf /src/* /tmp/* /var/lib/apt/lists/* 

COPY rootfs/ /

ENTRYPOINT [ "/init" ]

EXPOSE 5001/tcp
