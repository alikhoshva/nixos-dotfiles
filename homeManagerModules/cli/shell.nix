{ config, lib, ... }: {
  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    OZONE_PLATFORM = "wayland";
    SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/gcr/ssh";
    DEVENV_CACHIX_PUSH = "aleks-nixos-cache";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_QPA_PLATFORMTHEME = "gtk3";
    QT_STYLE_OVERRIDE = "gtk3";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    STARSHIP_CONFIG = lib.mkForce "${config.xdg.configHome}/starship/starship.toml";
  };

  systemd.user.sessionVariables = config.home.sessionVariables;


  home.sessionPath = [ "$HOME/.local/bin" ];

  programs.bash = {
    enable = true;
    shellAliases = {
      v = "nvim";
      vim = "nvim";
      sv = "sudo nvim";
      di = "devenv-init";
      up = "git -C ~/nixos-dotfiles pull && nh os switch";
      up-dev = "git -C ~/nixos-dotfiles checkout dev && git -C ~/nixos-dotfiles pull && nh os switch";
      up-main = "git -C ~/nixos-dotfiles checkout main && git -C ~/nixos-dotfiles pull && nh os switch";
    };
    initExtra = ''
            function y() {
              local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
              command yazi "$@" --cwd-file="$tmp"
              IFS= read -r -d ''' cwd < "$tmp"
              [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
              rm -f -- "$tmp"
            } 

            function devenv-init() {
              devenv init
              cat << \EOF > .envrc
      #!/usr/bin/env bash

      eval "$(devenv direnvrc)"

      # You can pass flags to the devenv command
      # For example: use devenv --impure --option services.postgres.enable:bool true
      use devenv
      EOF
              direnv allow
            }

            eval "$(devenv hook bash)"
    '';
  };
}
