#!/usr/bin/env bash
set -Eeuo pipefail

new_version="$(date +%m%d).$(date +%-H).$(date +%-M)"

# Find all files containing "version" followed by a three-number pattern and replace
grep -rlE --exclude-dir=.git "version.*[0-9]+\.[0-9]+\.[0-9]+" . | while IFS= read -r f; do
  sed -i -E "s/([0-9]+\.[0-9]+\.[0-9]+)/${new_version}/g" "$f"
done

git add .
git commit -m "$new_version"
git push

echo "Bumped -> $new_version"
