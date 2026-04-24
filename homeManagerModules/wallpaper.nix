{ pkgs, pkgs-unstable, ... }:

{
  home.packages = with pkgs; [
    mpvpaper
    wofi
    pywal
    imagemagick
    pkgs-unstable.awww
    pkgs-unstable.ani-cli
    (pkgs-unstable.yazi.override { _7zz = pkgs._7zz-rar; })
  ];
}
