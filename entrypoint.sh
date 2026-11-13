#!/usr/bin/env bash

set -o nounset
set -o errexit
set -o pipefail

# ANSI escape codes
red_bold=$'\e[1;31m'
reset=$'\e[0m'

# Prints an error message and exits the script.
#
# Arguments:
#   * (string): The error message.
die() {
	echo -e "${red_bold}ERROR${reset} ${@}" >&2
	exit 1
}

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
