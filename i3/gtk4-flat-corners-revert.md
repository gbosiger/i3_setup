# GTK4 Flat Corners Revert

This repo's GTK4 override is intentionally small:

- `theme-toggle-catppuccin` writes `~/.config/gtk-4.0/gtk.css`
- `theme-toggle-catppuccin` writes `~/.config/gtk-4.0/gtk-dark.css`
- both import the active Catppuccin GTK4 theme CSS
- both also import `~/.config/gtk-4.0/no-rounded-corners.css`

To revert only the flat-corners override while keeping the GTK4 theme override active:

1. Edit `~/.config/gtk-4.0/gtk.css` so it imports only the theme CSS.
2. Edit `~/.config/gtk-4.0/gtk-dark.css` so it imports only the theme CSS.
3. Remove `~/.config/gtk-4.0/no-rounded-corners.css`.
4. Remove the `no-rounded-corners.css` import and file-generation block from `i3/scripts/theme-toggle-catppuccin` if you do not want future theme toggles to restore it.

Example target state:

```css
@import url("file:///home/gebo/.themes/Catppuccin-Mauve-Dark-Frappe/gtk-4.0/gtk.css");
```

```css
@import url("file:///home/gebo/.themes/Catppuccin-Mauve-Dark-Frappe/gtk-4.0/gtk-dark.css");
```

If you want to disable the repo-managed GTK4 override entirely, set:

```bash
export CATPPUCCIN_GTK4_MODE=native
```

Then rerun `theme-toggle-catppuccin`.
