{ config, lib, inputs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  # Standard .config/directory
  configs = {
    waybar = "waybar";
    wofi = "wofi";
    hypr = "hypr";
    scripts = "scripts";
    wlogout = "wlogout";
    kitty = "kitty";
    Thunar = "Thunar";
    wal = "wal";
    #nvim = "nvim";
  };
in {
  home.username = "aleks";
  home.homeDirectory = "/home/aleks";
  programs.git.enable = true;
  home.stateVersion = "25.11";
  programs.bash = {
    enable = true;
    shellAliases = {
      v = "nvim";
      vim = "nvim";
      sv = "sudo nvim";
    };
    initExtra = ''
      function y() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        command yazi "$@" --cwd-file="$tmp"
        IFS= read -r -d ''' cwd < "$tmp"
        [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
        rm -f -- "$tmp"
      }
    '';
  };
  programs.home-manager.enable = true;
  programs.fzf.enableBashIntegration = true;

  xdg.configFile = builtins.mapAttrs (name: subpath: {

    source = create_symlink "${dotfiles}/${subpath}";

    recursive = true;

  }) configs;
  #force rebuild 3
}
