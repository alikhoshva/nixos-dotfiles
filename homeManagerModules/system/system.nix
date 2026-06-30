{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Backends & Daemons
    qt5.qtwayland
    qt6.qtwayland
    libnotify

    # Media & Archives
    ffmpeg
    unzip
    zip
    p7zip
  ];
}
