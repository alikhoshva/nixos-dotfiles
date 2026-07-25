{ pkgs, ... }:

{
  programs.nh = {
    enable = true;
    flake = "/home/aleks/nixos-dotfiles";
    clean = {
      enable = true;
      extraArgs = "--keep-since 4d --keep 3";
    };
  };

  home.packages = with pkgs; [
    nvd
    nix-output-monitor
  ];
}

