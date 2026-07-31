#!/usr/bin/env bash
# Generalized Display Mode & UI Scaling Script
# Usage:
#   set_display_mode.sh --preset <desktop-4k|game-1080p|laptop-only|dual-monitor>
#   set_display_mode.sh --output HDMI-A-1 --mode 3840x2160@120 --scale 1.5 --disable eDP-1

OUTPUT="HDMI-A-1"
MODE="3840x2160@120"
SCALE="1.5"
POSITION="0x0"
DISABLE="eDP-1"
PRESET=""
DUAL_MODE=false

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --preset)
      PRESET="$2"
      shift 2
      ;;
    -o|--output)
      OUTPUT="$2"
      shift 2
      ;;
    -m|--mode)
      MODE="$2"
      shift 2
      ;;
    -s|--scale)
      SCALE="$2"
      shift 2
      ;;
    -p|--pos|--position)
      POSITION="$2"
      shift 2
      ;;
    -d|--disable)
      DISABLE="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

# Handle presets
if [[ -n "$PRESET" ]]; then
  case "$PRESET" in
    desktop-4k)
      OUTPUT="HDMI-A-1"
      MODE="3840x2160@120"
      SCALE="1.5"
      POSITION="0x0"
      DISABLE="eDP-1"
      ;;
    game-1080p)
      OUTPUT="HDMI-A-1"
      MODE="1920x1080@120"
      SCALE="1.0"
      POSITION="0x0"
      DISABLE="eDP-1"
      ;;
    laptop-only)
      OUTPUT="eDP-1"
      MODE="1920x1200@60"
      SCALE="1.0"
      POSITION="0x0"
      DISABLE="HDMI-A-1"
      ;;
    dual-monitor|dual)
      DUAL_MODE=true
      SCALE="1.0"
      ;;
    *)
      echo "Unknown preset: $PRESET"
      exit 1
      ;;
  esac
fi

# 1. Hyprland Monitor Configuration (Keep monitor scale = 1 to prevent Zen Browser double-scaling)
if [[ "$DUAL_MODE" == true ]]; then
  hyprctl eval 'hl.monitor({ output = "eDP-1", mode = "1920x1200@60", position = "0x0", scale = 1, disabled = false }) hl.monitor({ output = "HDMI-A-1", mode = "3840x2160@120", position = "1920x0", scale = 1, disabled = false })' 2>/dev/null || {
    hyprctl keyword monitor "eDP-1, 1920x1200@60, 0x0, 1"
    hyprctl keyword monitor "HDMI-A-1, 3840x2160@120, 1920x0, 1"
  }
else
  hyprctl eval "hl.monitor({ output = \"$DISABLE\", disabled = true }) hl.monitor({ output = \"$OUTPUT\", mode = \"$MODE\", position = \"$POSITION\", scale = 1, disabled = false })" 2>/dev/null || {
    hyprctl keyword monitor "$DISABLE, disable"
    hyprctl keyword monitor "$OUTPUT, $MODE, $POSITION, 1"
  }
fi

# 2. Dynamic Kitty Font Size & Live Scaling
KITTY_FONT_SIZE=$(awk "BEGIN {printf \"%.1f\", 12.0 * $SCALE}")
hyprctl eval "hl.env(\"KITTY_FONT_SIZE\", \"$KITTY_FONT_SIZE\")" 2>/dev/null
dbus-update-activation-environment --systemd KITTY_FONT_SIZE="$KITTY_FONT_SIZE" 2>/dev/null
# Live update running Kitty instances if socket control is active
kitty @ --to=unix:@mykitty set-font-size "$KITTY_FONT_SIZE" 2>/dev/null &

# 3. Dynamic Cursor Scaling (Base 24px * SCALE -> 36px on 4K)
CURSOR_SIZE=$(awk "BEGIN {print int(24 * $SCALE + 0.5)}")
hyprctl setcursor catppuccin-mocha-light-cursors "$CURSOR_SIZE" 2>/dev/null
hyprctl eval "hl.env(\"HYPRCURSOR_THEME\", \"catppuccin-mocha-light-cursors\") hl.env(\"HYPRCURSOR_SIZE\", \"$CURSOR_SIZE\") hl.env(\"XCURSOR_THEME\", \"catppuccin-mocha-light-cursors\") hl.env(\"XCURSOR_SIZE\", \"$CURSOR_SIZE\") hl.env(\"GTK_CURSOR_SIZE\", \"$CURSOR_SIZE\")" 2>/dev/null
dbus-update-activation-environment --systemd HYPRCURSOR_THEME="catppuccin-mocha-light-cursors" HYPRCURSOR_SIZE="$CURSOR_SIZE" XCURSOR_THEME="catppuccin-mocha-light-cursors" XCURSOR_SIZE="$CURSOR_SIZE" GTK_CURSOR_SIZE="$CURSOR_SIZE" 2>/dev/null
dconf write /org/gnome/desktop/interface/cursor-size "$CURSOR_SIZE" 2>/dev/null

# 3.5. Save dynamic scale factor for application wrappers
mkdir -p ~/.config
echo "$SCALE" > ~/.config/ui_scale

# Sync GTK 3/4 settings files if writable
for gtk_file in ~/.config/gtk-3.0/settings.ini ~/.config/gtk-4.0/settings.ini; do
  if [[ -f "$gtk_file" && -w "$gtk_file" && ! -L "$gtk_file" ]]; then
    if grep -q "gtk-cursor-theme-size" "$gtk_file"; then
      sed -i "s/gtk-cursor-theme-size=.*/gtk-cursor-theme-size=$CURSOR_SIZE/" "$gtk_file" 2>/dev/null
    else
      echo "gtk-cursor-theme-size=$CURSOR_SIZE" >> "$gtk_file" 2>/dev/null
    fi
  fi
done

# 4. Live X11/XWayland DPI, Xcursor & GTK Text Calculation
DPI=$(awk "BEGIN {print int($SCALE * 96 + 0.5)}")
if command -v xrdb &> /dev/null; then
  printf "Xft.dpi: %s\nXcursor.size: %s\nXcursor.theme: catppuccin-mocha-light-cursors\n" "$DPI" "$CURSOR_SIZE" | xrdb -merge
fi
dconf write /org/gnome/desktop/interface/text-scaling-factor "$SCALE"

# 5. Multi-Toolkit Hyprland & DBus Session Environment Variables (GTK/Qt/Chromium/Electron/Xft/Cursor)
hyprctl eval "hl.env(\"QT_AUTO_SCREEN_SCALE_FACTOR\", \"0\") hl.env(\"QT_ENABLE_HIGHDPI_SCALING\", \"1\") hl.env(\"QT_SCALE_FACTOR\", \"$SCALE\") hl.env(\"QT_SCALE_FACTOR_ROUNDING_POLICY\", \"PassThrough\") hl.env(\"GDK_SCALE\", \"1\") hl.env(\"GDK_DPI_SCALE\", \"$SCALE\") hl.env(\"CHROMIUM_USER_FLAGS\", \"--force-device-scale-factor=$SCALE\") hl.env(\"ELECTRON_EXTRA_LAUNCH_ARGS\", \"--force-device-scale-factor=$SCALE\") hl.env(\"XFT_DPI\", \"$DPI\")" 2>/dev/null
dbus-update-activation-environment --systemd QT_AUTO_SCREEN_SCALE_FACTOR=0 QT_ENABLE_HIGHDPI_SCALING=1 QT_SCALE_FACTOR="$SCALE" QT_SCALE_FACTOR_ROUNDING_POLICY="PassThrough" GDK_SCALE=1 GDK_DPI_SCALE="$SCALE" CHROMIUM_USER_FLAGS="--force-device-scale-factor=$SCALE" ELECTRON_EXTRA_LAUNCH_ARGS="--force-device-scale-factor=$SCALE" XFT_DPI="$DPI" HYPRCURSOR_SIZE="$CURSOR_SIZE" XCURSOR_SIZE="$CURSOR_SIZE" 2>/dev/null

# 6. Restart Noctalia (quickshell) with updated scale factor
pkill -f quickshell 2>/dev/null
pkill -f noctalia-shell 2>/dev/null
sleep 0.5
QT_AUTO_SCREEN_SCALE_FACTOR=0 QT_SCALE_FACTOR="$SCALE" QT_SCALE_FACTOR_ROUNDING_POLICY="PassThrough" noctalia-shell &> /dev/null & disown
