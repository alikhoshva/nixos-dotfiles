{ pkgs, ... }:

{
  home.packages = with pkgs; [
    mpvpaper
    wofi
    pywal
    imagemagick
    unstable.awww
  ];
}
