#!/usr/bin/env bash
set -euo pipefail

THEME="${1:-frappe}"
DIR="$HOME/.config/kitty/themes"
SOCKET_GLOB="/tmp/kitty-${USER}*"

case "$THEME" in
  catppuccin-latte)  FILE="$DIR/latte.conf" ;;
  catppuccin-frappe) FILE="$DIR/frappe.conf" ;;
  catppuccin-macchiato) FILE="$DIR/macchiato.conf" ;;
  catppuccin-mocha) FILE="$DIR/mocha.conf" ;;
  *) echo "Usage: set_kitty_theme {catppuccin-latte|catppuccin-frappe|catppuccin-macchiato|catppuccin-mocha}" >&2; exit 1 ;;
esac

SOCKETS=()
for CANDIDATE in $SOCKET_GLOB; do
  if [ -S "$CANDIDATE" ]; then
    SOCKETS+=("$CANDIDATE")
  fi
done

if [ "${#SOCKETS[@]}" -eq 0 ]; then
  echo "No kitty instance reachable at $SOCKET_GLOB. Start kitty first." >&2
  exit 1
fi

for SOCKET in "${SOCKETS[@]}"; do
  kitty @ --to "unix:$SOCKET" set-colors -a --configured "$FILE"
done
