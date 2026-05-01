#!/usr/bin/env bash
set -euo pipefail

step="5%"
sink="@DEFAULT_SINK@"

notify_volume() {
  local body="$1"
  local value="${2:-}"

  if command -v dunstctl >/dev/null 2>&1; then
    dunstctl set-paused false >/dev/null 2>&1 || true
  fi

  if command -v dunstify >/dev/null 2>&1 && pgrep -x dunst >/dev/null 2>&1; then
    if [[ -n "$value" ]]; then
      dunstify -a "volume" -u low -h int:value:"$value" -r 991049 "Volume" "$body"
    else
      dunstify -a "volume" -u low -r 991049 "Volume" "$body"
    fi
    return 0
  fi

  notify-send "Volume" "$body" >/dev/null 2>&1 || true
}

case "${1:-}" in
  up)
    pactl set-sink-mute "$sink" 0
    pactl set-sink-volume "$sink" +"$step"
    ;;
  down)
    pactl set-sink-volume "$sink" -"$step"
    ;;
  mute)
    pactl set-sink-mute "$sink" toggle
    ;;
  *)
    exit 1
    ;;
esac

muted="$(pactl get-sink-mute "$sink" | awk '{print $2}')"
if [[ "$muted" == "yes" ]]; then
  notify_volume "󰖁  Muted"
  exit 0
fi

vol="$(pactl get-sink-volume "$sink" | awk -F'/' '/Volume:/ {gsub(/ /, "", $2); gsub(/%/, "", $2); print $2; exit}')"
notify_volume "󰕾  ${vol:-0}%" "${vol:-0}"
