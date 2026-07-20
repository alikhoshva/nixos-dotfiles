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
  # Note: `programs.nh` module is kept disabled due to compatibility issues with Determinate Nix.
  # We package our custom standalone script from config/scripts/nh.sh into an executable binary on $PATH.
  home.packages = [ nhScript ];
}

