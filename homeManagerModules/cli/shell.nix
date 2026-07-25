{ lib, ... }: {
  home.sessionVariables = {
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/gcr/ssh";
    DEVENV_CACHIX_PUSH = "aleks-nixos-cache";
    XFT_DPI = "96";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    STARSHIP_CONFIG = "$HOME/.config/starship/starship.toml";
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

      function _nh_complete() {
        local cur prev words cword
        cur="''${COMP_WORDS[COMP_CWORD]}"
        prev="''${COMP_WORDS[COMP_CWORD-1]}"
        cword="$COMP_CWORD"

        case "$cword" in
          1)
            COMPREPLY=( $(compgen -W "os home clean diff update" -- "$cur") )
            ;;
          2)
            case "''${COMP_WORDS[1]}" in
              os)
                COMPREPLY=( $(compgen -W "switch test boot dry-build build" -- "$cur") )
                ;;
              home)
                COMPREPLY=( $(compgen -W "switch build" -- "$cur") )
                ;;
              clean)
                COMPREPLY=( $(compgen -W "7d 14d 30d" -- "$cur") )
                ;;
            esac
            ;;
          3)
            case "''${COMP_WORDS[1]}" in
              os|home)
                COMPREPLY=( $(compgen -W "--dry --fast --show-trace --help" -- "$cur") )
                ;;
            esac
            ;;
        esac
      }
      complete -F _nh_complete nh

      eval "$(devenv hook bash)"
    '';
  };
}
