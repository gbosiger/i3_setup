#!/usr/bin/env bash
set -euo pipefail

ROFI_CONFIG="$HOME/.config/rofi/config.rasi"
ACTIVE_MARKER="›"

profile_icon() {
  case "$1" in
    performance) printf '%s' "󰓅" ;;
    balanced) printf '%s' "󰾅" ;;
    power-saver) printf '%s' "󰾆" ;;
    *) printf '%s' "󰈐" ;;
  esac
}

if ! command -v powerprofilesctl >/dev/null 2>&1; then
  notify-send "CPU Profile" "powerprofilesctl is not installed"
  exit 1
fi

current_profile="$(powerprofilesctl get 2>/dev/null || true)"

mapfile -t profiles < <(
  powerprofilesctl list 2>/dev/null |
    grep -E '^[ *]+[a-z0-9-]+:' |
    sed -E 's/^[ *]+([a-z0-9-]+):.*/\1/'
)

if [[ ${#profiles[@]} -eq 0 ]]; then
  notify-send "CPU Profile" "No power profiles found"
  exit 1
fi

menu_entries=()
for profile in "${profiles[@]}"; do
  icon="$(profile_icon "$profile")"
  if [[ "$profile" == "$current_profile" ]]; then
    menu_entries+=("$ACTIVE_MARKER  $icon  $profile")
  else
    menu_entries+=("   $icon  $profile")
  fi
done

choice="$({ printf '%s\n' "${menu_entries[@]}"; } | rofi -dmenu -i -p "CPU Profile" -config "$ROFI_CONFIG")"
choice="$(printf '%s' "$choice" | sed -E 's/^[^[:alnum:]]+[[:space:]]+//; s/^[^[:alnum:]]+[[:space:]]+//')"

if [[ -z "$choice" || "$choice" == "$current_profile" ]]; then
  exit 0
fi

if powerprofilesctl set "$choice"; then
  notify-send "CPU Profile" "Switched to $choice"
else
  notify-send "CPU Profile" "Failed to switch to $choice"
  exit 1
fi
