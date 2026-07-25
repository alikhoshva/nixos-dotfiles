{ pkgs, ... }:

let
  nhScript = pkgs.writeShellApplication {
    name = "nh";
    runtimeInputs = with pkgs; [
      git
      nix-output-monitor
      nvd
    ];
    text = builtins.readFile ./../../config/scripts/nh.sh;
  };
in
{
  home.sessionVariables = {
    FLAKE = "/home/aleks/nixos-dotfiles";
    NH_OS_FLAKE = "/home/aleks/nixos-dotfiles";
  };

  home.packages = [ nhScript ];
}

