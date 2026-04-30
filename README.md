# i3_setup for Regolith

This repo is the source of truth for my Regolith/i3 look:
- GTK + icon + cursor theme switching (Latte/Frappe)
- Kitty theme sync
- Polybar theme sync
- Rofi launcher theme sync
- Catppuccin thin-line window styling in Regolith

## Packages
```bash
sudo apt install kitty rofi picom polybar playerctl pulseaudio-utils fonts-font-awesome fonts-noto-color-emoji
```

## One-time bootstrap
```bash
bash ~/Projects/i3_setup/i3/scripts/bootstrap-regolith.sh
```

This creates/refreshes these links:
- `~/.config/regolith3/i3 -> ~/Projects/i3_setup/i3`
- `~/.config/i3 -> ~/Projects/i3_setup/i3`
- `~/.config/polybar -> ~/Projects/i3_setup/polybar`
- `~/.config/rofi -> ~/Projects/i3_setup/rofi`
- `~/.config/kitty -> ~/Projects/i3_setup/kitty`
- `~/.local/bin/theme-toggle-catppuccin -> ~/Projects/i3_setup/i3/scripts/theme-toggle-catppuccin`

It also writes Regolith user Xresources overrides:
- `wm.bar.mode: invisible`
- `wm.bar.status_command: /bin/true`

So only Polybar is visible (no second Regolith/i3xrocks bar).

## Daily usage
```bash
theme-toggle-catppuccin latte
theme-toggle-catppuccin frappe
```

Notes:
- GTK4 apps may need restart for full custom CSS changes.
- The theme script keeps `~/.config/regolith3/Xresources` in sync via a managed block.
