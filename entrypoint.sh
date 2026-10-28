#!/usr/bin/env bash

set -eo pipefail

# Run OpenCode in the Devbox environment, if available
if [ -f 'devbox.json' ]; then
	devbox run opencode "${@}"
fi

# Run OpenCode in the current process
exec opencode "${@}"
