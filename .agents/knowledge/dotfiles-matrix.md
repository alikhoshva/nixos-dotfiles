# Desktop Config & Dotfiles Matrix

This document maps raw user dotfile configurations under `config/` to their target symlink locations in the user home directory (`~/.config/`).

---

## Configuration Mapping Table

| Folder in `config/` | Target Link (`~/.config/`) | Managed By | Description |
| :--- | :--- | :--- | :--- |
| `config/hypr` | `~/.config/hypr` | `homeManagerModules/desktop/symlinks.nix` | Hyprland compositor settings, keybinds, monitors |
| `config/waybar` | `~/.config/waybar` | `homeManagerModules/desktop/symlinks.nix` | Waybar status bar styling and layout modules |
| `config/noctalia` | `~/.config/noctalia` | `homeManagerModules/desktop/symlinks.nix` | Noctalia shell / dynamic desktop UI theme |
| `config/kitty` | `~/.config/kitty` | `homeManagerModules/desktop/symlinks.nix` | Kitty terminal emulator configuration |
| `config/walker` | `~/.config/walker` | `homeManagerModules/desktop/symlinks.nix` | Walker application runner configuration |
| `config/wofi` | `~/.config/wofi` | `homeManagerModules/desktop/symlinks.nix` | Wofi menu launcher fallback |
| `config/wlogout` | `~/.config/wlogout` | `homeManagerModules/desktop/symlinks.nix` | Wlogout session menu layout and CSS |
| `config/starship` | `~/.config/starship.toml` | `homeManagerModules/cli/starship.nix` | Starship cross-shell prompt configuration |
| `config/yazi` | `~/.config/yazi` | `homeManagerModules/desktop/symlinks.nix` | Yazi terminal file manager configuration |
| `config/wal` | `~/.config/wal` | `homeManagerModules/desktop/symlinks.nix` | Pywal color scheme templates & themes |
| `config/Thunar` | `~/.config/Thunar` | `homeManagerModules/desktop/symlinks.nix` | Thunar file manager settings |
| `config/scripts` | `~/.config/scripts` | `homeManagerModules/desktop/symlinks.nix` | Helper desktop scripts (screenshot, picker, etc.) |
| `config/assets` | `~/.config/assets` | `homeManagerModules/desktop/symlinks.nix` | Static assets, wallpapers, icons |

---

## Guidelines for Modifying Dotfiles

1. **Edit Raw Configs Directly**: Make edits inside `config/<app>/...` rather than modifying `~/.config/` directly.
2. **Symlink Registration**: If adding a brand new application dotfile directory inside `config/`, register the symlink target in `homeManagerModules/desktop/symlinks.nix` using Home Manager's `xdg.configFile` or `home.file`.
3. **Stage Changes**: Remember to `git add config/<app>` so Nix Flakes pick up new files during evaluation.
