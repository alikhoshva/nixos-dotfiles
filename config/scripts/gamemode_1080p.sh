#!/usr/bin/env bash
# Game Mode: Switch display to 1080p@120Hz and set live text/font DPI scaling to 1.0

# 1. Hyprland monitor switch to 1080p on HDMI-A-1
hyprctl eval 'hl.monitor({ output = "eDP-1", disabled = true }) hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@120", position = "0x0", scale = 1, disabled = false })' || hyprctl keyword monitor HDMI-A-1,1920x1080@120,0x0,1

# 2. Live GTK text scaling down to 1.0
dconf write /org/gnome/desktop/interface/text-scaling-factor 1.0

# 3. Live X11/XWayland DPI down to 96 (base 1080p DPI)
if command -v xrdb &> /dev/null; then
  echo "Xft.dpi: 96" | xrdb -merge
fi
