FROM jetpackio/devbox:latest

USER root

RUN DEBIAN_FRONTEND=noninteractive apt update \
    && apt install -y --no-install-recommends \
      curl \
      git \
      gh \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

USER ${DEVBOX_USER}:${DEVBOX_USER}

RUN curl -fsSL https://opencode.ai/v2/install | bash -s -- --no-modify-path
ENV PATH="/home/${DEVBOX_USER}/.opencode/bin:${PATH}"

COPY --chmod=755 entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
