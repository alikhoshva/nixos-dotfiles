---
name: nix-anti-bloat
description: Use when adding or refactoring NixOS or Home Manager options to ensure zero redundancy and minimal codebase bloat.
---

# Nix Anti-Bloat Skill

Use this skill whenever creating or editing Nix files to keep the codebase lean and free of unnecessary default declarations.

## Anti-Bloat Verification Checklist

1. **Default Value Check**:
   - Never write `enable = false;`, `extraConfig = "";`, or `settings = {};` if those are already the implicit defaults.
   - Refer to [.agents/knowledge/nix-defaults-and-antipatterns.md](file:///.agents/knowledge/nix-defaults-and-antipatterns.md) for common defaults.

2. **Package Redundancy Check**:
   - Check if a package (e.g. `pkgs.waybar`, `pkgs.git`) is already pulled in by an active program/service module before adding it to `home.packages` or `environment.systemPackages`.

3. **Raw Config vs. Inline String Check**:
   - If configuring desktop applications (Hyprland, Waybar, Noctalia, Kitty), edit raw dotfiles under `config/` and link via `symlinks.nix` rather than embedding massive inline multi-line strings in Nix.

4. **Automated Static Scan**:
   - Run `.agents/scripts/check-bloat.sh` to verify your changes contain no redundant declarations.
