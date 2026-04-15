{ pkgs,pkgs-unstable, ... }:

{
  home.packages = with pkgs; [
    mpvpaper
    wofi
    pywal
    imagemagick
    pkgs-unstable.awww
  ];
}
