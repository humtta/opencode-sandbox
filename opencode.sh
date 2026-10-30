#!/usr/bin/env bash

set -eo pipefail

image_id='opencode-sandbox'

repo_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
agents_dir="${HOME}/.agents"
opencode_dir="${HOME}/.config/opencode"
container_home='/home/devbox'

# Prints the help message.
usage() {
	# Tabs and spaces mixed on purpose
	cat <<-EOF
		Run OpenCode in a Docker sandbox.

		Usage: ${0##*/} [OPTION]... [-- ARG...]

		Options:
		  -r, --rebuild    Rebuild the Docker image before starting OpenCode
		  -h, --help       Show this help message and exit
	EOF
}

# Default option values
rebuild_opt=false

# Parse options
while [[ "${#}" -gt 0 ]]; do
	case "${1}" in
		-r | --rebuild) rebuild_opt=true && shift ;;
		-h | --help) usage && exit 0 ;;
		*) usage && exit 1 ;;
	esac
done

# Check if Docker is installed
if ! command -v docker &>/dev/null; then
	echo 'Error: docker is not installed' >&2
	exit 1
fi

# Build the image on the first run or whenever the rebuild option is given
if "${rebuild_opt}" || ! docker image inspect "${image_id}" >/dev/null 2>&1; then
	docker build --pull --no-cache -t "${image_id}" "${repo_dir}"
fi

# Set the working directory
work_dir="${PWD}"

echo "Working directory: ${work_dir}"

# Base arguments for running the container
args=(run -it --rm -v "${work_dir}:/workspace" -w /workspace)

# Persist Nix store
args+=(-v nix-store:/nix/store)

# Mount the agents configuration directory if it exists
if [[ -d "${agents_dir}" ]]; then
	args+=(-v "${agents_dir}:${container_home}/.agents")
fi

# Mount the OpenCode configuration directory if it exists
if [[ -d "${opencode_dir}" ]]; then
	args+=(-v "${opencode_dir}:${container_home}/.config/opencode")
fi

# Run container in the current process
exec docker "${args[@]}" "${image_id}"
