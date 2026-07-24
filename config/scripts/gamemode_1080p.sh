#!/usr/bin/env bash
# Game Mode: Switch display to 1080p@120Hz, reset GTK/Qt scale environment, and reset Noctalia UI to 1.0

# 1. Hyprland monitor switch to 1080p on HDMI-A-1 and disable eDP-1
hyprctl eval 'hl.monitor({ output = "eDP-1", disabled = true }) hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@120", position = "0x0", scale = 1, disabled = false })' 2>/dev/null || {
  hyprctl keyword monitor "eDP-1, disable"
  hyprctl keyword monitor "HDMI-A-1, 1920x1080@120, 0x0, 1"
}

# 2. Reset Hyprland Lua & DBus session environment variables for newly launched apps
hyprctl eval 'hl.env("QT_SCALE_FACTOR", "1.0") hl.env("GDK_SCALE", "1") hl.env("ELM_SCALE", "1.0")'
dbus-update-activation-environment --systemd QT_SCALE_FACTOR=1.0 GDK_SCALE=1 ELM_SCALE=1.0 2>/dev/null

# 3. Live GTK text scaling down to 1.0
dconf write /org/gnome/desktop/interface/text-scaling-factor 1.0

# 4. Live X11/XWayland DPI down to 96 (base 1080p DPI)
if command -v xrdb &> /dev/null; then
  echo "Xft.dpi: 96" | xrdb -merge
fi

# 5. Restart Noctalia (quickshell) back to 1.0x scale for 1080p
pkill -f quickshell 2>/dev/null
pkill -f noctalia-shell 2>/dev/null
sleep 0.5
QT_SCALE_FACTOR=1.0 noctalia-shell &> /dev/null & disown


