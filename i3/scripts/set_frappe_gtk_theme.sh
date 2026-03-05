#!/bin/bash
# Set Catppuccin GTK theme for GTK and GNOME apps

# Set the GTK theme for current session
gsettings set org.gnome.desktop.interface gtk-theme "Catppuccin-Mauve-Light-Frappe"
gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark" # or your preferred icon theme

export GTK_THEME=Catppuccin-Mauve-Light-Frappe
