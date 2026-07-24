#!/usr/bin/env bash
# Desktop 4K Mode: Switch display to 4K@120Hz and set live text/font DPI scaling to 1.5

# 1. Hyprland monitor switch to 4K on HDMI-A-1
hyprctl eval 'hl.monitor({ output = "eDP-1", disabled = true }) hl.monitor({ output = "HDMI-A-1", mode = "3840x2160@120", position = "0x0", scale = 1, disabled = false })' || hyprctl keyword monitor HDMI-A-1,3840x2160@120,0x0,1

# 2. Live GTK text scaling back to 1.5
dconf write /org/gnome/desktop/interface/text-scaling-factor 1.5

# 3. Live X11/XWayland DPI back to 144 (1.5x 4K DPI)
if command -v xrdb &> /dev/null; then
  echo "Xft.dpi: 144" | xrdb -merge
fi
