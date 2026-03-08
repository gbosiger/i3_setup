#!/usr/bin/env bash
set -euo pipefail

THEME="${1:-toggle}"

STATE_DIR="$HOME/.config/theme"
POLYBAR_DIR="$HOME/.config/polybar/themes"
ROFI_DIR="$HOME/.config/rofi/themes"
KITTY_DIR="$HOME/.config/kitty/themes"

CURRENT_FILE="$STATE_DIR/current"

mkdir -p "$STATE_DIR"

current_theme() {
  if [ -f "$CURRENT_FILE" ]; then
    cat "$CURRENT_FILE"
  else
    echo "frappe"
  fi
}

resolve_theme() {
  case "$1" in
    latte|frappe|macchiato)
      echo "$1"
      ;;
    toggle)
      case "$(current_theme)" in
        frappe) echo "latte" ;;
        latte) echo "macchiato" ;;
        macchiato) echo "frappe" ;;
        *) echo "frappe" ;;
      esac
      ;;
    *)
      echo "Usage: switch-theme [latte|frappe|macchiato|toggle]" >&2
      exit 1
      ;;
  esac
}

apply_gnome_scheme() {
  local theme="$1"

  if command -v gsettings >/dev/null 2>&1; then
    case "$theme" in
      latte)
        gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
        gsettings set org.gnome.desktop.interface gtk-theme 'Catppuccin-Latte-Standard-Blue-Light'
        gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Light'
        ;;
      frappe)
        gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
        gsettings set org.gnome.desktop.interface gtk-theme 'Catppuccin-Frappe-Standard-Blue-Dark'
        gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
        ;;
      macchiato)
        gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
        gsettings set org.gnome.desktop.interface gtk-theme 'Catppuccin-Macchiato-Standard-Blue-Dark'
        gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
        ;;
    esac
  fi
}

apply_links() {
  local theme="$1"

  ln -sf "$POLYBAR_DIR/$theme.ini" "$POLYBAR_DIR/current.ini"

  [ -f "$ROFI_DIR/$theme.rasi" ] && \
    ln -sf "$ROFI_DIR/$theme.rasi" "$ROFI_DIR/current.rasi"

  if [ -f "$KITTY_DIR/$theme.conf" ]; then
    ln -sf "$KITTY_DIR/$theme.conf" "$KITTY_DIR/current.conf"
  fi
}

sync_opencode_mode() {
  local theme="$1"
  local mode="dark"
  local kv_file="$HOME/.local/state/opencode/kv.json"

  if [ "$theme" = "latte" ]; then
    mode="light"
  fi

  if [ -f "$kv_file" ]; then
    python3 - "$kv_file" "$mode" <<'PY'
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
}

reload_apps() {
  "$HOME/.config/polybar/launch.sh" >/dev/null 2>&1 || true

  if command -v kitty >/dev/null 2>&1; then
    kitty @ set-colors -a -c "$HOME/.config/kitty/themes/current.conf" >/dev/null 2>&1 || true
  fi

  pkill -USR2 -x opencode >/dev/null 2>&1 || true

  pkill -USR1 -x xsettingsd >/dev/null 2>&1 || true
  xrdb -merge "$HOME/.Xresources" >/dev/null 2>&1 || true
}

main() {
  THEME="$(resolve_theme "$THEME")"
  echo "$THEME" > "$CURRENT_FILE"

  apply_links "$THEME"
  apply_gnome_scheme "$THEME"
  sync_opencode_mode "$THEME"
  reload_apps

  notify-send "Theme switched" "Now using Catppuccin ${THEME^}" >/dev/null 2>&1 || true
}

main "$@"
