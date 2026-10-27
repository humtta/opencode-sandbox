#!/usr/bin/env bash

set -eo pipefail

# Prints the help message.
usage() {
	# Tabs and spaces mixed on purpose
	cat <<-EOF
		Usage: ${0} [OPTION]...

		Options:
		  -r, --rebuild    Rebuilds the Docker image
		  -t, --temp       Opens OpenCode in an empty temporary directory
	EOF
}

# Default flag values
rebuild=false
temp=false

# Parse flags
while [[ "${#}" -gt 0 ]]; do
	case "${1}" in
		-r|--rebuild)
			rebuild=true
			shift
			;;

		-t|--temp)
			temp=true
			shift
			;;
	esac
done
