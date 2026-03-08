#!/usr/bin/env bash
set -euo pipefail

THEME="${1:-catppuccin-frappe}"
DIR="$HOME/.config/kitty/themes"
SOCKET_GLOB="/tmp/kitty-${USER}*"
KV_FILE="$HOME/.local/state/opencode/kv.json"

case "$THEME" in
  catppuccin-latte)
    FILE="$DIR/latte.conf"
    MODE="light"
    ;;
  catppuccin-frappe)
    FILE="$DIR/frappe.conf"
    MODE="dark"
    ;;
  catppuccin-macchiato)
    FILE="$DIR/macchiato.conf"
    MODE="dark"
    ;;
  catppuccin-mocha)
    FILE="$DIR/mocha.conf"
    MODE="dark"
    ;;
  *)
    echo "Usage: set_kitty_theme {catppuccin-latte|catppuccin-frappe|catppuccin-macchiato|catppuccin-mocha}" >&2
    exit 1
    ;;
esac

if [ ! -f "$FILE" ]; then
  echo "Theme file not found: $FILE" >&2
  exit 1
fi

# Persist for new kitty instances
ln -sf "$FILE" "$DIR/current.conf"

# Update all running kitty instances (best effort)
SOCKETS=()
for CANDIDATE in $SOCKET_GLOB; do
  if [ -S "$CANDIDATE" ]; then
    SOCKETS+=("$CANDIDATE")
  fi
done

for SOCKET in "${SOCKETS[@]}"; do
  kitty @ --to "unix:$SOCKET" set-colors -a --configured "$FILE" >/dev/null 2>&1 || true
done

# Keep OpenCode system mode aligned with theme flavor
if [ -f "$KV_FILE" ]; then
  python3 - "$KV_FILE" "$MODE" <<'PY'
import json
import sys

path = sys.argv[1]
mode = sys.argv[2]
with open(path, 'r', encoding='utf-8') as f:
    data = json.load(f)
data['theme'] = 'system'
data['theme_mode'] = mode
with open(path, 'w', encoding='utf-8') as f:
    json.dump(data, f, indent=2)
    f.write('\n')
PY
fi

# Tell running OpenCode to refresh palette cache
pkill -USR2 -x opencode >/dev/null 2>&1 || true
