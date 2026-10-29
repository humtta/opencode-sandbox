#!/usr/bin/env bash

set -eo pipefail

# Run OpenCode in the Devbox environment, if available
if [[ -f 'devbox.json' ]] || [[ -f 'devbox.jsonc' ]]; then
	exec devbox run opencode "${@}"
fi

# Run OpenCode in the current process
exec opencode "${@}"
