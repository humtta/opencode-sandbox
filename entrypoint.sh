#!/usr/bin/env bash

set -o nounset
set -o errexit
set -o pipefail

# ANSI escape codes
cyan=$'\e[0;36m'
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

# Checks if one or more variables exist and are non-empty.
#
# Arguments:
#   * (string): The variable name(s).
check_var() {
	for var in "${@}"; do
		if [[ ! -n "${!var:-}" ]]; then
			die "Variable ${cyan}${var}${reset} is undefined."
		fi
	done
}

# Sets up the GPG key.
#
# Globals:
#   GPG_KEY_FINGERPRINT
#   GPG_PUBLIC_KEY_URL
#
# Arguments:
#   None
setup_gpg() {
	curl -fsS "${GPG_PUBLIC_KEY_URL}" | gpg --quiet --import

	# Check if the expected key was actually imported
	if ! gpg --list-keys "${GPG_KEY_FINGERPRINT}" >/dev/null 2>&1; then
		die "Key ${GPG_KEY_FINGERPRINT} not found at ${GPG_PUBLIC_KEY_URL}."
	fi

	# Increase the key's trust level
	echo "${GPG_KEY_FINGERPRINT}:6:" | gpg --import-ownertrust
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

# Check environment variables
check_var \
	'GIT_USER_NAME' \
	'GIT_USER_EMAIL' \
	'GPG_KEY_FINGERPRINT' \
	'GPG_PUBLIC_KEY_URL'

setup_gpg
run_opencode
