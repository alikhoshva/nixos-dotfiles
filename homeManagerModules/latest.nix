{ pkgs-unstable, ... }:

{
  home.packages = with pkgs-unstable; [
    ani-cli
    dbeaver-bin
    devcontainer
    (yazi.override { _7zz = pkgs._7zz-rar; })
  ];
}
