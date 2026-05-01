#!/usr/bin/env bash
set -euo pipefail

cursor_theme=""
cursor_size="24"

if command -v gsettings >/dev/null 2>&1; then
  cursor_theme="$(gsettings get org.gnome.desktop.interface cursor-theme 2>/dev/null | tr -d "'" || true)"
  cursor_size="$(gsettings get org.gnome.desktop.interface cursor-size 2>/dev/null || echo 24)"
fi

if [[ -z "$cursor_theme" && -f "$HOME/.config/gtk-3.0/settings.ini" ]]; then
  cursor_theme="$(sed -n 's/^gtk-cursor-theme-name=//p' "$HOME/.config/gtk-3.0/settings.ini" | head -n1 || true)"
fi

if [[ -z "$cursor_theme" && -f "$HOME/.icons/default/index.theme" ]]; then
  cursor_theme="$(sed -n 's/^Inherits=//p' "$HOME/.icons/default/index.theme" | head -n1 || true)"
fi

if [[ -z "$cursor_theme" ]]; then
  exit 0
fi

export XCURSOR_THEME="$cursor_theme"
export XCURSOR_SIZE="$cursor_size"

for base in "$HOME/.local/share/icons" "$HOME/.icons" "/usr/share/icons"; do
  cursor_file="$base/$cursor_theme/cursors/left_ptr"
  if [[ -r "$cursor_file" ]]; then
    xsetroot -xcf "$cursor_file" "$cursor_size"
    exit 0
  fi
done

exit 0
