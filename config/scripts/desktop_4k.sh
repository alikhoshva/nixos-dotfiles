#!/usr/bin/env bash
# Desktop 4K Mode: Switch display to 4K@120Hz, set GTK/Qt scale environment, and scale Noctalia UI to 1.5

# 1. Hyprland monitor switch to 4K on HDMI-A-1 and disable eDP-1
hyprctl eval 'hl.monitor({ output = "eDP-1", disabled = true }) hl.monitor({ output = "HDMI-A-1", mode = "3840x2160@120", position = "0x0", scale = 1, disabled = false })' 2>/dev/null || {
  hyprctl keyword monitor "eDP-1, disable"
  hyprctl keyword monitor "HDMI-A-1, 3840x2160@120, 0x0, 1"
}

# 2. Set Hyprland & DBus session environment variables for newly launched apps
hyprctl setenv QT_SCALE_FACTOR 1.5
hyprctl setenv GDK_SCALE 1
hyprctl setenv ELM_SCALE 1.5
dbus-update-activation-environment --systemd QT_SCALE_FACTOR=1.5 GDK_SCALE=1 ELM_SCALE=1.5 2>/dev/null

# 3. Live GTK text scaling to 1.5
dconf write /org/gnome/desktop/interface/text-scaling-factor 1.5

# 4. Live X11/XWayland DPI back to 144 (1.5x 4K DPI)
if command -v xrdb &> /dev/null; then
  echo "Xft.dpi: 144" | xrdb -merge
fi

# 5. Restart noctalia-shell with 1.5x Qt scaling factor so bar and UI scale up on 4K
if pkill -f noctalia-shell; then
  QT_SCALE_FACTOR=1.5 noctalia-shell &> /dev/null & disown
fi


