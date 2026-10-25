#!/usr/bin/env bash

set -eo pipefail

# Run OpenCode in the current process
exec opencode "${@}"
