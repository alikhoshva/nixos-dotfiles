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
    inputs.zen-browser.homeModules.twilight
    inputs.spicetify-nix.homeManagerModules.spicetify
  ];

  programs.home-manager.enable = true;
  news.display = "silent";
  home.stateVersion = "25.11";
}
