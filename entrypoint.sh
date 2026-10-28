#!/usr/bin/env bash

set -eo pipefail

# Run OpenCode in the Devbox environment, if available
if [ -f 'devbox.json' ]; then
	exec devbox run opencode --standalone --auto "${@}"
fi

# Run OpenCode in the current process
exec opencode --standalone --auto "${@}"
