#!/usr/bin/env bash

set -u

killall -q polybar

while pgrep -x polybar >/dev/null; do sleep 1; done

monitors=()

for _ in {1..10}; do
  mapfile -t monitors < <(polybar --list-monitors)

  if [[ ${#monitors[@]} -gt 0 ]]; then
    break
  fi

  sleep 1
done

if [[ ${#monitors[@]} -eq 0 ]]; then
  exit 0
fi

primary_monitor=""

for line in "${monitors[@]}"; do
  monitor="${line%%:*}"

  if [[ "$line" == *"(primary)"* ]]; then
    primary_monitor="$monitor"
    break
  fi
done

if [[ -z "$primary_monitor" ]]; then
  primary_monitor="${monitors[0]%%:*}"
fi

for line in "${monitors[@]}"; do
  monitor="${line%%:*}"

  if [[ -z "$monitor" ]]; then
    continue
  fi

  tray_position="none"
  if [[ "$monitor" == "$primary_monitor" ]]; then
    tray_position="right"
  fi

  env MONITOR="$monitor" TRAY_POSITION="$tray_position" polybar main >/dev/null 2>&1 & disown || true
done
