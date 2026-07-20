{ config, lib, inputs, pkgs, ... }:

{
  imports = [ 
    inputs.walker.homeManagerModules.default 
  ];

  programs.elephant = {
    enable = true;
    installService = false;
  };

  programs.walker = {
    enable = true;
    runAsService = false;
  };

  # Override Walker module's generated config files with our out-of-store symlinks
  xdg.configFile."walker/style.css".source = config.lib.file.mkOutOfStoreSymlink "/home/aleks/nixos-dotfiles/config/walker/style.css";
  xdg.configFile."walker/config.toml".source = lib.mkForce (config.lib.file.mkOutOfStoreSymlink "/home/aleks/nixos-dotfiles/config/walker/config.toml");
}
