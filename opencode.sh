#!/usr/bin/env bash

set -eo pipefail

prog="${0##*/}"

image_id='opencode-sandbox'

repo_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
agents_dir="${HOME}/.agents"
opencode_dir="${HOME}/.config/opencode"
container_home='/home/devbox'

# Parameters
rebuild='false'
directory="${PWD}"

# ANSI escape codes
gray=$'\e[0;90m'
cyan=$'\e[0;36m'
red_bold=$'\e[1;31m'
bold=$'\e[1m'
reset=$'\e[0m'

# Prints an error message and exits the script.
#
# Arguments:
#   * (string): The error message.
die() {
	echo -e "${red_bold}ERROR${reset} ${@}" >&2
	exit 1
}

# Prints the help message.
#
# Arguments:
#   None
usage() {
	# Tabs and spaces mixed on purpose
	cat <<-EOF
		${bold}DESCRIPTION${reset}
		  Run OpenCode in a Docker sandbox.

		${bold}USAGE${reset}
		  ${cyan}${prog} ${gray}[<directory>] [options]${reset}

		${bold}ARGUMENTS${reset}
		  ${cyan}directory${reset}    Directory where OpenCode will be started ${gray}(optional)${reset}

		${bold}OPTIONS${reset}
		  ${cyan}-r, --rebuild${reset}    Rebuild the Docker image before starting OpenCode
		  ${cyan}-h, --help${reset}       Print this help message and exit
	EOF
}

# Parses the CLI arguments.
#
# Arguments:
#   1 (directory): Directory where the Docker container will be mounted (optional).
#
# Options:
#   -r, --rebuild (boolean): Rebuilds the Docker image.
#   -h, --help (boolean): Prints the help message and exits.
parse_args() {
	positional_args=()

	while [[ "${#}" -gt 0 ]]; do
		case "${1}" in
			-r | --rebuild)
				rebuild='true'
				shift
				;;

			-h | --help)
				usage
				exit 0
				;;

			-*)
				die "Unknown option: ${cyan}${1}${reset}. Run ${cyan}${prog} -h${reset} for help."
				;;

			*)
				positional_args+=("${1}")
				shift
				;;
		esac
	done

	case "${#positional_args[@]}" in
		0)
			;;

		1)
			if [[ ! -d "${positional_args[0]}" ]]; then
				die "Directory not found: ${cyan}${positional_args[0]}${reset}."
			fi
			directory="${positional_args[0]}"
			;;

		*)
			die "Too many arguments: expected at most one ${cyan}directory${reset}."
			;;
	esac
}

# Check if Docker is installed
if ! command -v docker &>/dev/null; then
	echo 'Error: docker is not installed' >&2
	exit 1
fi

# Build the image on the first run or whenever the rebuild option is given
if "${rebuild}" || ! docker image inspect "${image_id}" >/dev/null 2>&1; then
	docker build --pull --no-cache -t "${image_id}" "${repo_dir}"
fi

# Base arguments for running the container
args=(run -it --rm -v "${directory}:/workspace" -w /workspace)

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
