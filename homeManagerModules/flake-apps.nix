{ inputs, pkgs, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
in
{

  home.packages = [
    inputs.anipy-cli.packages.${system}.default
    inputs.nvim-config.packages.${system}.default
    inputs.antigravity-nix.packages.${system}.google-antigravity-no-fhs
    #inputs.antigravity-nix.packages.${system}.google-antigravity-ide
    inputs.antigravity-nix.packages.${system}.google-antigravity-cli

  ];

}
