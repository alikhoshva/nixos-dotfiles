#!/usr/bin/env bash
# Simplified Display Mode & Scaling Script
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
      ;;
    *)
      echo "Unknown preset: $PRESET"
      exit 1
      ;;
  esac
fi

# 1. Hyprland Monitor Scaling
if [[ "$DUAL_MODE" == true ]]; then
  hyprctl eval 'hl.monitor({ output = "eDP-1", mode = "1920x1200@60", position = "0x0", scale = 1, disabled = false }) hl.monitor({ output = "HDMI-A-1", mode = "3840x2160@120", position = "1920x0", scale = 1, disabled = false })' 2>/dev/null || {
    hyprctl keyword monitor "eDP-1, 1920x1200@60, 0x0, 1"
    hyprctl keyword monitor "HDMI-A-1, 3840x2160@120, 1920x0, 1"
  }
else
  hyprctl eval "hl.monitor({ output = \"$DISABLE\", disabled = true }) hl.monitor({ output = \"$OUTPUT\", mode = \"$MODE\", position = \"$POSITION\", scale = $SCALE, disabled = false })" 2>/dev/null || {
    hyprctl keyword monitor "$DISABLE, disable"
    hyprctl keyword monitor "$OUTPUT, $MODE, $POSITION, $SCALE"
  }
fi



# 2.5 Save scale factor for application wrappers
mkdir -p ~/.config
echo "$SCALE" > ~/.config/ui_scale

# 3. Restart Noctalia Shell
pkill -f quickshell 2>/dev/null
pkill -f noctalia-shell 2>/dev/null
sleep 0.5
noctalia-shell &> /dev/null & disown
