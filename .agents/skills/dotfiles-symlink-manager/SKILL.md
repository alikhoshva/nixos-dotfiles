---
name: dotfiles-symlink-manager
description: Use when editing user desktop application dotfiles under config/ or modifying Home Manager symlinks.
---

# Dotfiles Symlink Manager Skill

Follow this workflow when modifying raw application dotfiles (Waybar, Hyprland, Noctalia, Kitty, Wofi, Walker, etc.).

## Workflow Steps

1. **Edit Raw Dotfiles in `config/`**:
   - Always edit raw dotfile assets directly inside `config/<app_name>/`.
   - Never attempt to manually write to `~/.config/` directly; let Home Manager maintain symlinks.

2. **Symlink Target Registration**:
   - Check [.agents/knowledge/dotfiles-matrix.md](file:///.agents/knowledge/dotfiles-matrix.md) to locate existing target mappings.
   - If adding a new app configuration folder under `config/`, open `homeManagerModules/desktop/symlinks.nix` and add the `xdg.configFile` or `home.file` symlink entry.

3. **Stage Changes**:
   - Remember to run `git add config/` so Nix Flakes pick up new dotfile assets.

4. **Verify Symlink Configuration**:
   - Run `.agents/scripts/verify.sh` to ensure Home Manager dry-run evaluation succeeds.
