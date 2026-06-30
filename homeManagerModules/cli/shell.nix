{ lib, ... }: {
  home.sessionVariables = {
    STARSHIP_CONFIG = lib.mkForce "$HOME/.config/starship/starship.toml";
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/gcr/ssh";
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
