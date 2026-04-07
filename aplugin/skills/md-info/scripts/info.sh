#!/usr/bin/env bash
set -Eeuo pipefail

file="${1:-}"

if [[ -z "$file" ]]; then
  echo "usage: info.sh <file.md>" >&2
  exit 1
fi

if [[ ! -f "$file" ]]; then
  echo "error: file not found: $file" >&2
  exit 1
fi

lines=$(wc -l < "$file")
words=$(wc -w < "$file")
chars=$(wc -c < "$file")
headers=$(grep -c '^#' "$file" || true)
links=$(grep -oE '\[.+\]\(.+\)' "$file" | wc -l || true)
images=$(grep -oE '!\[.+\]\(.+\)' "$file" | wc -l || true)
code_blocks=$(grep -c '^\`\`\`' "$file" || true)

echo "file    : $file"
echo "lines   : $lines"
echo "words   : $words"
echo "chars   : $chars"
echo "headers : $headers"
echo "links   : $links"
echo "images  : $images"
echo "code blocks (fences): $((code_blocks / 2))"
