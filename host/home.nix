{
  config,
  lib,
  inputs,
  ...
}:

{
  home.username = "aleks";
  home.homeDirectory = "/home/aleks";

  imports = [
    ../homeManagerModules
    inputs.zen-browser.homeModules.twilight
    inputs.spicetify-nix.homeManagerModules.spicetify
  ];

  programs.home-manager.enable = true;
  home.stateVersion = "25.11";
}
