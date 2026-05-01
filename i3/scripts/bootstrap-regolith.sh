#!/usr/bin/env bash
set -euo pipefail

ROOT="$HOME/Projects/i3_setup"

mkdir -p "$HOME/.config"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.config/regolith3"

ln -sfn "$ROOT/i3" "$HOME/.config/regolith3/i3"
ln -sfn "$ROOT/i3" "$HOME/.config/i3"
ln -sfn "$ROOT/polybar" "$HOME/.config/polybar"
ln -sfn "$ROOT/rofi" "$HOME/.config/rofi"
ln -sfn "$ROOT/kitty" "$HOME/.config/kitty"
ln -sfn "$ROOT/dunst" "$HOME/.config/dunst"
ln -sfn "$ROOT/i3/scripts/theme-toggle-catppuccin" "$HOME/.local/bin/theme-toggle-catppuccin"

XRES="$HOME/.config/regolith3/Xresources"
touch "$XRES"

python3 - "$XRES" <<'PY'
import pathlib
import re
import sys

path = pathlib.Path(sys.argv[1])
content = path.read_text(encoding='utf-8', errors='replace') if path.exists() else ''

def upsert_line(text, key, value):
    pattern = re.compile(rf'^{re.escape(key)}\s*:.*$', re.M)
    line = f'{key}: {value}'
    if pattern.search(text):
        return pattern.sub(line, text)
    if text and not text.endswith('\n'):
        text += '\n'
    return text + line + '\n'

content = upsert_line(content, 'wm.bar.mode', 'invisible')
content = upsert_line(content, 'wm.bar.status_command', '/bin/true')
content = upsert_line(content, 'wm.program.logout', '~/.config/i3/scripts/session-menu-rofi.sh')

path.write_text(content, encoding='utf-8')
PY

xrdb -merge "$XRES" || true
i3-msg reload >/dev/null 2>&1 || true

echo "Bootstrap complete."
