FROM jetpackio/devbox:latest

USER root

RUN DEBIAN_FRONTEND=noninteractive apt update \
    && apt install -y --no-install-recommends \
      curl \
      git \
      gh \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*
