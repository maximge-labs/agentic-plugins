#!/usr/bin/env bash
set -Eeuo pipefail

file="${1:-}"

if [[ -z "$file" ]]; then
  echo "usage: info.sh <script.sh>" >&2
  exit 1
fi

if [[ ! -f "$file" ]]; then
  echo "error: file not found: $file" >&2
  exit 1
fi

if [[ "$file" != *.sh ]]; then
  echo "warning: file does not have .sh extension" >&2
fi

# Basic counts
lines=$(awk 'END{print NR}' "$file")
words=$(wc -w < "$file")
chars=$(wc -c < "$file")
empty_lines=$(grep -c '^[[:space:]]*$' "$file" || true)

# Shebang
shebang=$(head -1 "$file" | grep '^#!' || echo "(none)")

# Comments (lines starting with #, excluding shebang)
comment_lines=$(awk 'NR>1 && /^[[:space:]]*#/' "$file" | wc -l | tr -d ' ')
# Add 1 for shebang if present
if head -1 "$file" | grep -q '^#!'; then
  total_comments=$((comment_lines + 1))
else
  total_comments=$comment_lines
fi

# Functions — matches both `fname()` and `function fname` styles
func_count=$(grep -cE '^\s*(function\s+\w+|[a-zA-Z_][a-zA-Z0-9_]*\s*\(\))' "$file" || true)
func_names=$(grep -oE '(function\s+\w+|[a-zA-Z_][a-zA-Z0-9_]*)\s*\(\)' "$file" \
  | sed 's/function //' | sed 's/\s*()//' | head -10 || true)

# Variables — assignments like VAR= or local VAR=
var_count=$(grep -cE '^\s*(export\s+|local\s+|readonly\s+|declare\s+)?[a-zA-Z_][a-zA-Z0-9_]*=' "$file" || true)

# Pipes
pipe_count=$(grep -o '|' "$file" | wc -l | tr -d ' ')

# Sourced files — source or dot includes
sourced=$(grep -oE '(\.|source)\s+[^ ;]+' "$file" | awk '{print $NF}' || true)
source_count=$(echo "$sourced" | grep -c . || true)
if [[ -z "$sourced" ]]; then
  source_count=0
fi

# Subshells — $( ... )
subshell_count=$(grep -o '\$(' "$file" | wc -l | tr -d ' ')

# Conditionals
if_count=$(grep -cE '^\s*if\b' "$file" || true)
case_count=$(grep -cE '^\s*case\b' "$file" || true)

# Loops
for_count=$(grep -cE '^\s*for\b' "$file" || true)
while_count=$(grep -cE '^\s*while\b' "$file" || true)

# Top external commands (filter out shell builtins and keywords)
top_commands=$(awk '!/^[[:space:]]*#/ && !/^[[:space:]]*$/' "$file" \
  | sed 's/|/\n/g' | sed 's/;/\n/g' | sed 's/&&/\n/g' | sed 's/||/\n/g' \
  | awk '{gsub(/^[[:space:]]+/,"",$0); print $1}' \
  | grep -vE '^(if|then|else|elif|fi|for|do|done|while|until|case|esac|function|local|export|readonly|declare|return|exit|echo|printf|set|shift|eval|exec|trap|true|false|test|\[|\[\[|\{|\})$' \
  | grep -E '^[a-z]' \
  | sort | uniq -c | sort -rn | head -5 \
  | awk '{printf "  %s (%s)\n", $2, $1}' || true)

# set +x safety
uses_set_e=$(grep -q 'set.*-.*e' "$file" && echo "yes" || echo "no")
uses_set_u=$(grep -q 'set.*-.*u' "$file" && echo "yes" || echo "no")
uses_pipefail=$(grep -q 'pipefail' "$file" && echo "yes" || echo "no")

echo "=== Shell Script Analysis ==="
echo "file          : $file"
echo "shebang       : $shebang"
echo ""
echo "--- Size ---"
echo "lines         : $lines"
echo "words         : $words"
echo "chars         : $chars"
echo "empty lines   : $empty_lines"
echo ""
echo "--- Structure ---"
echo "functions     : $func_count"
if [[ -n "$func_names" ]]; then
  echo "$func_names" | awk '{printf "  → %s\n", $0}'
fi
echo "comments      : $total_comments"
echo "variables     : $var_count"
echo "pipes         : $pipe_count"
echo "subshells     : $subshell_count"
echo "sourced files : $source_count"
if [[ -n "$sourced" && "$source_count" -gt 0 ]]; then
  echo "$sourced" | awk '{printf "  → %s\n", $0}'
fi
echo ""
echo "--- Control Flow ---"
echo "if/elif       : $if_count"
echo "case          : $case_count"
echo "for           : $for_count"
echo "while         : $while_count"
echo ""
echo "--- Safety ---"
echo "set -e        : $uses_set_e"
echo "set -u        : $uses_set_u"
echo "pipefail      : $uses_pipefail"
echo ""
echo "--- Top Commands ---"
if [[ -n "$top_commands" ]]; then
  echo "$top_commands"
else
  echo "  (none detected)"
fi
