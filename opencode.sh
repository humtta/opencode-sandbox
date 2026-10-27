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
rebuild_opt=false
temp=false

# Parse options
while [[ "${#}" -gt 0 ]]; do
	case "${1}" in
		-h|--help)
			usage
			exit 0
			;;

		-r|--rebuild)
			rebuild_opt=true
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
if "${rebuild_opt}" || ! docker image inspect "${image_id}" >/dev/null 2>&1; then
	docker build -t "${image_id}" "${repo_dir}"
fi

# Work in the current directory or in a temporary directory if the temp option
# is given
if "${temp}"; then
	work_dir="$(mktemp -d)"
else
	work_dir="${PWD}"
fi

echo "Working directory: ${work_dir}"

# Base arguments for running the container
args=(run -it --rm -v "${work_dir}:/workspace" -w /workspace)
