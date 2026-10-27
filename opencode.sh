#!/usr/bin/env bash

set -eo pipefail

image_id='opencode-sandbox'

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Prints the help message.
usage() {
	# Tabs and spaces mixed on purpose
	cat <<-EOF
		Usage: ${0} [OPTION]...

		Options:
		  -r, --rebuild    Rebuilds the Docker image
		  -t, --temp       Opens OpenCode in an empty temporary directory
		  -h, --help       Prints this help message
	EOF
}

# Default option values
rebuild=false
temp=false

# Parse options
while [[ "${#}" -gt 0 ]]; do
	case "${1}" in
		-h|--help)
			usage
			exit 0
			;;

		-r|--rebuild)
			rebuild=true
			shift
			;;

		-t|--temp)
			temp=true
			shift
			;;

		*)
			usage
			exit 1
			;;
	esac
done

# Build the image on the first run or whenever the rebuild option is given
if "${rebuild}" || ! docker image inspect "${image_id}" >/dev/null 2>&1; then
	docker build -t "${image_id}" "${repo_dir}"
fi
