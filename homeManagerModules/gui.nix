{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Shell & Session
    hyprlock
    hyprpaper
    hypridle
    waybar
    eww
    wofi
    wlogout
    swaynotificationcenter
    networkmanagerapplet

    # GUI Applications
    kitty
    xfce.thunar
    xarchiver
    cloud-utils
    #librewolf
    vesktop
    zoom-us
    filezilla
    obsidian
    libreoffice
    prismlauncher
    pavucontrol

    # Desktop Utilities
    grim
    slurp
    swappy
    wl-clipboard
    playerctl
    brightnessctl
    nwg-look
    pywal
    mpvpaper
  ];
}
