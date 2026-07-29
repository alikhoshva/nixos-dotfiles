{ inputs, pkgs, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  home.packages = with inputs; [
    #anipy-cli.packages.${system}.default
    nvim-config.packages.${system}.default
    #curd.packages.${system}.default
    #inputs.antigravity-nix.packages.${system}.google-antigravity-no-fhs
    antigravity-nix.packages.${system}.google-antigravity-ide
    #inputs.antigravity-nix.packages.${system}.google-antigravity-cli

    # curd dependencies
    #pkgs.rofi
    #pkgs.ueberzugpp
  ];

}
