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
  catppuccin-latte-opencode|catppuccin-latte-opencode-system) FILE="$DIR/latte-opencode-system.conf" ;;
  catppuccin-frappe-opencode|catppuccin-frappe-opencode-system) FILE="$DIR/frappe-opencode-system.conf" ;;
  catppuccin-macchiato-opencode|catppuccin-macchiato-opencode-system) FILE="$DIR/macchiato-opencode-system.conf" ;;
  catppuccin-mocha-opencode|catppuccin-mocha-opencode-system) FILE="$DIR/mocha-opencode-system.conf" ;;
  *) echo "Usage: set_kitty_theme {catppuccin-latte|catppuccin-frappe|catppuccin-macchiato|catppuccin-mocha|catppuccin-latte-opencode|catppuccin-frappe-opencode|catppuccin-macchiato-opencode|catppuccin-mocha-opencode}" >&2; exit 1 ;;
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
