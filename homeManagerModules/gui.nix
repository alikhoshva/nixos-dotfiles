{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Shell & Session
    hyprlock
    hypridle
    waybar

    wlogout
    networkmanagerapplet
    seahorse

    # GUI Applications
    vivaldi
    kitty
    #google-chrome
    xarchiver
    cloud-utils
    #librewolf
    vesktop
    zoom-us
    filezilla
    obsidian
    libreoffice
    pavucontrol
    easyeffects
    (prismlauncher.override {
      jdks = [
        temurin-bin-17
        temurin-bin-21
        temurin-bin-25
      ];
    })
    # Desktop Utilities
    grim
    slurp
    swappy
    wl-clipboard
    playerctl
    brightnessctl
    nwg-look
    mpv
  ];
}
