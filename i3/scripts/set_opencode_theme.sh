#!/usr/bin/env bash
set -euo pipefail

THEME="${1:-frappe}"
DIR="$HOME/.config/opencode"

case "$THEME" in
  catppuccin-latte)  FILE="$DIR/tui.latte.json" ;;
  catppuccin-frappe) FILE="$DIR/tui.frappe.json" ;;
  catppuccin-macchiato) FILE="$DIR/tui.macchiato.json" ;;
  catppuccin-mocha) FILE="$DIR/tui.mocha.json" ;;
  *) echo "Usage: set_opencode_theme {catppuccin-latte|catppuccin-frappe|catppuccin-macchiato|catppuccin-mocha}" >&2; exit 1 ;;
esac

cp "$FILE" "$DIR/tui.json"
