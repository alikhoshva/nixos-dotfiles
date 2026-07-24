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
    if [[ "$action" =~ ^(switch|test|boot|build)$ ]] && command -v cachix >/dev/null 2>&1; then
      (nix build "$flake_dir#nixosConfigurations.nixos.config.system.build.toplevel" --json 2>/dev/null | jq -r '.[].outputs | to_entries[].value' | cachix push aleks-nixos-cache &>/dev/null &)
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
    if [[ "$action" =~ ^(switch|build)$ ]] && command -v cachix >/dev/null 2>&1; then
      (nix build "$flake_dir#homeConfigurations.aleks.activationPackage" --json 2>/dev/null | jq -r '.[].outputs | to_entries[].value' | cachix push aleks-nixos-cache &>/dev/null &)
    fi
    ;;
  clean)
    target="all"
    keep="7d"

    while [[ $# -gt 0 ]]; do
      case "$1" in
        all|system|user)
          target="$1"
          shift
          ;;
        -k|--keep)
          keep="${2:-7d}"
          shift 2 2>/dev/null || shift
          ;;
        *)
          keep="$1"
          shift
          ;;
      esac
    done

    # Standardize numeric keep values (e.g. 3 -> 3d) for nix-collect-garbage
    if [[ "$keep" =~ ^[0-9]+$ ]]; then
      keep="${keep}d"
    fi

    echo "Running Nix garbage collection (target: $target, keep: $keep)..."

    if [[ "$target" == "all" || "$target" == "user" ]]; then
      echo "Cleaning user profile generations..."
      if [[ "$keep" == "all" || "$keep" == "0d" ]]; then
        nix-collect-garbage -d 2>/dev/null || true
      else
        nix-collect-garbage --delete-older-than "$keep" 2>/dev/null || true
      fi
    fi

    if [[ "$target" == "all" || "$target" == "system" ]]; then
      echo "Cleaning system profile generations..."
      if [[ "$keep" == "all" || "$keep" == "0d" ]]; then
        sudo nix-collect-garbage -d 2>/dev/null || true
      else
        sudo nix-collect-garbage --delete-older-than "$keep" 2>/dev/null || true
      fi
    fi

    echo "Cleaning Nix store..."
    nix store gc 2>/dev/null || true

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
    echo "  nh clean [all|system|user] [--keep <period|num>]  (e.g., nh clean all --keep 3, nh clean 7d)"
    echo "  nh diff"
    echo "  nh update [input...]"
    echo "Aliases: nos = nh os switch, nhs = nh home switch, nhu = nh update"
    exit 1
    ;;
esac
