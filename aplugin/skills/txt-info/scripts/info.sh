#!/usr/bin/env bash
set -Eeuo pipefail

file="${1:-}"

if [[ -z "$file" ]]; then
  echo "usage: info.sh <file.txt>" >&2
  exit 1
fi

if [[ ! -f "$file" ]]; then
  echo "error: file not found: $file" >&2
  exit 1
fi

lines=$(wc -l < "$file")
words=$(wc -w < "$file")
chars=$(wc -c < "$file")
avg_line=$(awk 'NF{sum+=NF; n++} END{printf "%.1f", (n ? sum/n : 0)}' "$file")
empty_lines=$(grep -c '^$' "$file" || true)
top_words=$(tr -s '[:space:]' '\n' < "$file" \
  | tr '[:upper:]' '[:lower:]' \
  | grep -E '^[a-z]{3,}$' \
  | sort | uniq -c | sort -rn | head -5 \
  | awk '{printf "  %s (%s)\n", $2, $1}')

echo "file        : $file"
echo "lines       : $lines"
echo "words       : $words"
echo "chars       : $chars"
echo "empty lines : $empty_lines"
echo "avg words/line: $avg_line"
echo "top words:"
echo "$top_words"
