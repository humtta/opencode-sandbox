#!/usr/bin/env bash

set -o nounset
set -o errexit
set -o pipefail

# Runs OpenCode in the current process.
#
# Arguments:
#   None
run_opencode() {
	local command=(opencode --standalone --auto)

	# Run OpenCode in the Devbox environment, if available
	if [[ -f 'devbox.json' ]] || [[ -f 'devbox.jsonc' ]]; then
		command=(devbox run "${command[@]}")
	fi

	exec "${command[@]}"
}

run_opencode
