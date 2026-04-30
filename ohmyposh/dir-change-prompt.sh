#!/usr/bin/env bash
set -euo pipefail

last_cmd="${OMP_LAST_CMD:-}"

if [[ "$last_cmd" =~ ^[[:space:]]*(cd|pwd)([[:space:]]+.*)?$ ]]; then
  printf 'full\n'
else
  printf 'compact\n'
fi
