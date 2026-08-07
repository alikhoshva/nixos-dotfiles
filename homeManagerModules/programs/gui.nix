{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Shell & Session
    hyprlock
    hypridle
    hyprpolkitagent
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
    qdirstat
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
    ftb-app
    # Desktop Utilities
    xorg.xrdb
    grim
    slurp
    swappy
    wl-clipboard
    playerctl
    brightnessctl
    nwg-look
    mpv
  ];

  systemd.user.services.hyprpolkitagent = {
    Unit = {
      Description = "Hyprland Polkit Authentication Agent";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
      Restart = "on-failure";
      TimeoutStopSec = "5sec";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  systemd.user.targets.hyprland-session = {
    Unit = {
      Description = "Hyprland session";
      BindsTo = [ "graphical-session.target" ];
      Wants = [
        "graphical-session.target"
        "graphical-session-pre.target"
      ];
      After = [ "graphical-session-pre.target" ];
      PropagatesStopTo = [ "graphical-session.target" ];
    };
  };
}
