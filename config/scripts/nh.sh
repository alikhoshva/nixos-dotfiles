#!/usr/bin/env bash
set -euo pipefail

flake_dir="${NH_OS_FLAKE:-$HOME/nixos-dotfiles}"
subcmd="${1:-}"
shift 2>/dev/null || true

# Warn if there are untracked files in the flake directory
if [ -d "$flake_dir/.git" ]; then
  if git -C "$flake_dir" status --porcelain 2>/dev/null | grep -q '^??'; then
    echo -e "\033[1;33m[nh warning]\033[0m Untracked files detected in $flake_dir. Run 'git add' to include them in Flake evaluations!"
  fi
fi

case "$subcmd" in
  os)
    action="${1:-switch}"
    shift 2>/dev/null || true
    if command -v nom >/dev/null 2>&1; then
      sudo -v && sudo nixos-rebuild "$action" --flake "$flake_dir#nixos" "$@" 2>&1 | nom
    else
      sudo -v && sudo nixos-rebuild "$action" --flake "$flake_dir#nixos" "$@"
    fi
    ;;
  home)
    action="${1:-switch}"
    shift 2>/dev/null || true
    if command -v nom >/dev/null 2>&1; then
      home-manager "$action" --flake "$flake_dir#aleks" "$@" 2>&1 | nom
    else
      home-manager "$action" --flake "$flake_dir#aleks" "$@"
    fi
    ;;
  clean)
    keep="${1:-7d}"
    echo "Running garbage collection (deleting older than $keep)..."
    sudo nix-collect-garbage --delete-older-than "$keep"
    nix store gc
    echo "Optimising Nix store..."
    nix store optimise 2>/dev/null || true
    ;;
  diff)
    if command -v nvd >/dev/null 2>&1; then
      echo "Diffing recent NixOS system profile generations..."
      profiles=( /nix/var/nix/profiles/system-*-link )
      if [ "${#profiles[@]}" -ge 2 ]; then
        nvd diff "${profiles[-2]}" "${profiles[-1]}"
      else
        echo "Fewer than 2 system profile generations found."
      fi
    else
      echo "nvd tool is not installed."
    fi
    ;;
  update)
    echo "Updating flake inputs in $flake_dir..."
    nix flake update --flake "$flake_dir" "$@"
    ;;
  *)
    echo "Usage: nh [os|home|clean|diff|update] [action|options]"
    echo "  nh os [switch|test|boot|dry-build] [options]"
    echo "  nh home [switch|build] [options]"
    echo "  nh clean [keep-period]  (e.g., nh clean 7d)"
    echo "  nh diff"
    echo "  nh update [input...]"
    echo "Aliases: nos = nh os switch, nhs = nh home switch, nhu = nh update"
    exit 1
    ;;
esac
