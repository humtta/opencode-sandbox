#!/usr/bin/env bash

set -eo pipefail

# Start the Devbox shell, if available
if [ -f 'devbox.json' ]; then
	devbox shell
fi

# Run OpenCode in the current process
exec opencode "${@}"
