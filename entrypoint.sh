#!/usr/bin/env bash

set -eo pipefail

# Base arguments for running OpenCode
args=(--standalone --auto)

# Run OpenCode in the Devbox environment, if available
if [ -f 'devbox.json' ]; then
	exec devbox run opencode "${args[@]}" "${@}"
fi

# Run OpenCode in the current process
exec opencode "${args[@]}" "${@}"
