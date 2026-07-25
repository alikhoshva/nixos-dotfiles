{ config, lib, ... }: {
  home.sessionVariables = {
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/gcr/ssh";
    DEVENV_CACHIX_PUSH = "aleks-nixos-cache";
    XFT_DPI = "96";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    STARSHIP_CONFIG = lib.mkForce "${config.xdg.configHome}/starship/starship.toml";
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      v = "nvim";
      vim = "nvim";
      sv = "sudo nvim";
      di = "devenv-init";
    };
    initExtra = ''
      export STARSHIP_CONFIG="${config.xdg.configHome}/starship/starship.toml"

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
