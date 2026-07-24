#!/usr/bin/env bash

# Create an array of your configuration files
files=(
    "$HOME/.config/hypr/hyprland.lua"
    "$HOME/.config/hypr/hyprpaper.conf"
    "$HOME/.config/hypr/hyprlock.conf"
    "$HOME/.config/hypr/hypridle.conf"
    "$HOME/.config/hypr/conf/animations.lua"
    "$HOME/.config/hypr/conf/autostart.lua"
    "$HOME/.config/hypr/conf/binds.lua"
    "$HOME/.config/hypr/conf/enviroments.lua"
    "$HOME/.config/hypr/conf/input.lua"
    "$HOME/.config/hypr/conf/look.lua"
    "$HOME/.config/hypr/conf/monitor.lua"
    "$HOME/.config/hypr/conf/perms.lua"
    "$HOME/.config/hypr/conf/windowrules.lua"
    "$HOME/.config/hypr/conf/workspaces.lua"
)

# Use wofi to create a menu and get the selected file
selected=$(printf "%s\n" "${files[@]}" | wofi --dmenu -p "Select a config file to edit")

# If a file was selected, open it in nvim
if [[ -n "$selected" ]]; then
    kitty nvim "$selected"
fi
