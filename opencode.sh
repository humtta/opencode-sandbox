#!/usr/bin/env bash

set -eo pipefail

# Default flag values
rebuild=false

# Parse flags
while [[ "${#}" -gt 0 ]]; do
	case "${1}" in
		-r|--rebuild)
			rebuild=true
			shift
			;;
	esac
done
