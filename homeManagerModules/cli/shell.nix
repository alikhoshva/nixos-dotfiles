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
      nos = "nh os switch";
      nhs = "nh home switch";
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

      function nh() {
        local flake_dir="''${NH_OS_FLAKE:-$HOME/nixos-dotfiles}"
        local subcmd="$1"
        shift 2>/dev/null || true

        # Warn if there are untracked files in the flake directory
        if [ -d "$flake_dir/.git" ]; then
          if git -C "$flake_dir" status --porcelain 2>/dev/null | grep -q '^\?\?'; then
            echo -e "\033[1;33m[nh warning]\033[0m Untracked files detected in $flake_dir. Run 'git add' to include them in Flake evaluations!"
          fi
        fi

        case "$subcmd" in
          os)
            local action="''${1:-switch}"
            shift 2>/dev/null || true
            if command -v nom >/dev/null 2>&1; then
              (set -o pipefail; sudo -v && sudo nixos-rebuild "$action" --flake "$flake_dir#nixos" "$@" 2>&1 | nom)
            else
              sudo -v && sudo nixos-rebuild "$action" --flake "$flake_dir#nixos" "$@"
            fi
            ;;
          home)
            local action="''${1:-switch}"
            shift 2>/dev/null || true
            if command -v nom >/dev/null 2>&1; then
              (set -o pipefail; home-manager "$action" --flake "$flake_dir#aleks" "$@" 2>&1 | nom)
            else
              home-manager "$action" --flake "$flake_dir#aleks" "$@"
            fi
            ;;
          clean)
            local keep="''${1:-7d}"
            echo "Running garbage collection (deleting older than $keep)..."
            sudo nix-collect-garbage --delete-older-than "$keep"
            nix store gc
            echo "Optimising Nix store..."
            nix store optimise 2>/dev/null || true
            ;;
          diff)
            if command -v nvd >/dev/null 2>&1; then
              echo "Diffing recent NixOS system profile generations..."
              local profiles=( /nix/var/nix/profiles/system-*-link )
              if [ ''${#profiles[@]} -ge 2 ]; then
                nvd diff "''${profiles[-2]}" "''${profiles[-1]}"
              else
                echo "Fewer than 2 system profile generations found."
              fi
            else
              echo "nvd tool is not installed."
            fi
            ;;
          *)
            echo "Usage: nh [os|home|clean|diff] [action] [options]"
            echo "  nh os [switch|test|boot|dry-build] [options]"
            echo "  nh home [switch|build] [options]"
            echo "  nh clean [keep-period]  (e.g., nh clean 7d)"
            echo "  nh diff"
            echo "Aliases: nos = nh os switch, nhs = nh home switch"
            return 1
            ;;
        esac
      }

      function _nh_complete() {
        local cur prev words cword
        cur="''${COMP_WORDS[COMP_CWORD]}"
        prev="''${COMP_WORDS[COMP_CWORD-1]}"
        cword="$COMP_CWORD"

        case "$cword" in
          1)
            COMPREPLY=( $(compgen -W "os home clean diff" -- "$cur") )
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
