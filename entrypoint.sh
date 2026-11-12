#!/usr/bin/env bash

set -eo pipefail

# Base command
command=(opencode --standalone --auto)

# Run OpenCode in the Devbox environment, if available
if [[ -f 'devbox.json' ]] || [[ -f 'devbox.jsonc' ]]; then
	command=(devbox run "${command[@]}")
fi

# Run OpenCode in the current process
exec "${command[@]}"
