{ pkgs, ... }:

{
  home.packages = with pkgs.unstable; [
    ani-cli
    devcontainer
    (yazi.override { _7zz = pkgs._7zz-rar; })
    #antigravity-fhs
    devenv
    pangolin-cli

  ];
}
