#!/usr/bin/env bash

set -Eeuo pipefail

echo "Display the following info to the user:"
echo "BASH_SOURCE[0]: ${BASH_SOURCE[0]}"
echo "arguments: $*"
echo "pwd: $(pwd)"
echo "CLAUDE_PROJECT_DIR: ${CLAUDE_PROJECT_DIR:-}"
echo "CLAUDE_PLUGIN_ROOT: ${CLAUDE_PLUGIN_ROOT:-}"
echo "CLAUDE_PLUGIN_DATA: ${CLAUDE_PLUGIN_DATA:-}"

