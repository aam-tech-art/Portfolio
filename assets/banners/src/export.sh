#!/usr/bin/env bash
# Exports banner HTML files to PNG with headless Chrome.
# Usage: bash assets/banners/src/export.sh <campaign-folder> <name.html>...
# The device mock-ups load the live website into their screens, so this needs internet.
set -e
cd "$(dirname "$0")"
CH="/c/Program Files/Google/Chrome/Application/chrome.exe"
out="../$1"; shift
mkdir -p "$out"
for html in "$@"; do
  name="${html%.html}"
  prof="$(mktemp -d)"
  "$CH" --headless --disable-gpu --no-first-run --hide-scrollbars --user-data-dir="$(cygpath -w "$prof")" \
    --window-size=1080,1080 --virtual-time-budget=30000 \
    --screenshot="$(cygpath -m "$PWD/$out/$name-1080x1080.png")" "file:///$(cygpath -m "$PWD/$html")" 2>&1 | grep -i "written" || echo "FAILED: $html"
  rm -rf "$prof"
done
