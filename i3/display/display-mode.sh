#!/usr/bin/env bash
set -euo pipefail

STATE_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/display-mode"
POLYBAR_LAUNCHER="$HOME/.config/polybar/launch.sh"
ROFI_THEME='
window { width: 360px; border-radius: 14px; padding: 18px; }
mainbox { children: [ inputbar, listview ]; spacing: 12px; }
inputbar { padding: 10px; border-radius: 10px; }
listview { lines: 3; columns: 1; fixed-height: false; spacing: 8px; }
element { padding: 10px; border-radius: 10px; }
element selected { border-radius: 10px; }
'

dual() {
  xrandr \
    --output DP-0 --primary --auto \
    --output eDP-1-1 --auto --below DP-0
  echo dual > "$STATE_FILE"
  relaunch_polybar
}

external() {
  xrandr \
    --output DP-0 --primary --auto \
    --output eDP-1-1 --off
  echo external > "$STATE_FILE"
  relaunch_polybar
}

laptop() {
  xrandr \
    --output eDP-1-1 --primary --auto \
    --output DP-0 --off
  echo laptop > "$STATE_FILE"
  relaunch_polybar
}

relaunch_polybar() {
  if [[ -x "$POLYBAR_LAUNCHER" ]]; then
    "$POLYBAR_LAUNCHER" >/dev/null 2>&1 & disown || true
  fi
}

menu() {
  choice="$(
    printf '%s\n' dual external laptop |
      rofi -dmenu -i \
        -p "Displays" \
        -theme-str "$ROFI_THEME"
  )"

  case "${choice:-}" in
    dual) dual ;;
    external) external ;;
    laptop) laptop ;;
    *) exit 0 ;;
  esac
}

cycle() {
  current="$(cat "$STATE_FILE" 2>/dev/null || true)"

  case "$current" in
    dual) external ;;
    external) laptop ;;
    laptop) dual ;;
    *) dual ;;
  esac
}

auto-lid-close() {
  external
}

auto-lid-open() {
  dual
}

case "${1:-}" in
  dual) dual ;;
  external) external ;;
  laptop) laptop ;;
  menu) menu ;;
  cycle) cycle ;;
  auto-lid-close) auto-lid-close ;;
  auto-lid-open) auto-lid-open ;;
  *)
    echo "Usage: display-mode {dual|external|laptop|menu|cycle|auto-lid-close|auto-lid-open}" >&2
    exit 1
    ;;
esac
