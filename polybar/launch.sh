#!/usr/bin/env bash

set -euo pipefail

killall -q polybar

while pgrep -x polybar >/dev/null; do sleep 1; done

primary_monitor="$(polybar --list-monitors | awk -F: '/ primary / {print $1; exit}')"

if [[ -z "$primary_monitor" ]]; then
  primary_monitor="$(polybar --list-monitors | awk -F: 'NR==1 {print $1; exit}')"
fi

polybar --list-monitors | while IFS=: read -r monitor _; do
  if [[ -z "$monitor" ]]; then
    continue
  fi

  tray_position="none"
  if [[ "$monitor" == "$primary_monitor" ]]; then
    tray_position="right"
  fi

  MONITOR="$monitor" TRAY_POSITION="$tray_position" polybar main &
done

wait
