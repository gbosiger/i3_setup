#!/usr/bin/env bash
set -euo pipefail

part="${1:-}"
mode="$($HOME/.config/ohmyposh/dir-change-prompt.sh)"
if [[ "$mode" == "compact" ]]; then
  exit 0
fi

user="$(id -un)"
cwd="$PWD"
home="$HOME"

if [[ "$cwd" == "$home" ]]; then
  short="~"
elif [[ "$cwd" == "$home"/* ]]; then
  rel="${cwd#$home/}"
  IFS='/' read -r -a parts <<< "$rel"
  if (( ${#parts[@]} > 2 )); then
    short="~/${parts[${#parts[@]}-2]}/${parts[${#parts[@]}-1]}"
  else
    short="~/$rel"
  fi
else
  rel="${cwd#/}"
  IFS='/' read -r -a parts <<< "$rel"
  if (( ${#parts[@]} > 2 )); then
    short="/${parts[${#parts[@]}-2]}/${parts[${#parts[@]}-1]}"
  else
    short="$cwd"
  fi
fi

branch="$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null || true)"

case "$part" in
  user)
    printf '  %s  ' "$user"
    ;;
  path)
    printf '  \uf115  %s  ' "$short"
    ;;
  git)
    if [[ -n "$branch" ]]; then
      printf '  \ue0a0  %s  ' "$branch"
    fi
    ;;
esac
