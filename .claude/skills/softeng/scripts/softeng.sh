#!/usr/bin/env bash

set -Eeuo pipefail

action="${1:-}"
shift

case "$action" in
  uchange)
    kebab_name=""
    issue_url=""

    while [[ $# -gt 0 ]]; do
      case "$1" in
        --kebab-name) kebab_name="$2"; shift 2 ;;
        --issue-url)  issue_url="$2";  shift 2 ;;
        *) shift ;;
      esac
    done

    if [[ -z "$kebab_name" ]]; then
      echo "error: --kebab-name is required" >&2
      exit 1
    fi

    change_folder="changes/${kebab_name}"
    mkdir -p "$change_folder"

    change_file="${change_folder}/change.md"

    {
      echo "---"
      echo "registered_at: $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
      if [[ -n "$issue_url" ]]; then
        echo "issue_url: ${issue_url}"
      fi
      echo "---"
    } > "$change_file"

    echo "change_file: ${change_file}"
    echo ""
    echo "Extend ${change_file} with the change request from {other-input}."
    echo "The change request should include the following sections:"
    echo "  ## Why"
    echo "  ## What"
    echo "  ## How"
    ;;

  *)
    echo "error: unknown action '${action}'" >&2
    exit 1
    ;;
esac
