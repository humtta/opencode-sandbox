FROM jetpackio/devbox:latest

USER root

# Install some system packages
RUN DEBIAN_FRONTEND=noninteractive apt update \
    && apt install -y --no-install-recommends \
      curl \
      gpg \
      git \
      gh \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

USER ${DEVBOX_USER}:${DEVBOX_USER}
ENV HOME="/home/${DEVBOX_USER}"

# Install OpenCode
RUN curl -fsSL https://opencode.ai/v2/install | bash -s -- --no-modify-path
ENV PATH="${HOME}/.opencode/bin:${PATH}"

# Create user configuration directory
RUN mkdir -p "${HOME}/.config"

# Prepare gpg configuration directory. The host agent socket is mounted here at
# runtime, so gpg should never attempt to start its own agent.
RUN mkdir -p "${HOME}/.gnupg" \
    && chmod 700 "${HOME}/.gnupg" \
    && echo 'no-autostart' > "${HOME}/.gnupg/gpg.conf"

# Run entrypoint script
COPY --chmod=755 entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
