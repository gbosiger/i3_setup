#!/usr/bin/env bash
set -euo pipefail

ROFI_CONFIG="$HOME/.config/rofi/config.rasi"

menu() {
  local prompt="$1"
  shift
  printf '%s\n' "$@" | rofi -dmenu -i -p "$prompt" -config "$ROFI_CONFIG"
}

choice="$(menu "Session" \
  "  Lock" \
  "  Logout" \
  "  Reboot" \
  "  Power Off")"

case "$choice" in
  "  Lock")
    loginctl lock-session
    ;;
  "  Logout")
    if command -v gnome-session-quit >/dev/null 2>&1; then
      gnome-session-quit --logout --no-prompt
    else
      i3-msg exit
    fi
    ;;
  "  Reboot")
    if command -v gnome-session-quit >/dev/null 2>&1; then
      gnome-session-quit --reboot
    else
      systemctl reboot
    fi
    ;;
  "  Power Off")
    if command -v gnome-session-quit >/dev/null 2>&1; then
      gnome-session-quit --power-off
    else
      systemctl poweroff
    fi
    ;;
  *)
    exit 0
    ;;
esac
