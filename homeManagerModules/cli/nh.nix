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

  home.sessionVariables = {
    FLAKE = "/home/aleks/nixos-dotfiles";
    NH_FLAKE = "/home/aleks/nixos-dotfiles";
  };

  home.packages = with pkgs; [
    nvd
    nix-output-monitor
  ];
}

