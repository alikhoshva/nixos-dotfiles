# NixOS & Home Manager Architecture Guide

This document serves as institutional memory for the system layout, module hierarchy, and design philosophy of `nixos-dotfiles`.

---

## Dynamic Tree Module Loading (`inputs.import-tree`)

This repository uses **`inputs.import-tree`** to dynamically and recursively discover and import all `.nix` files under `nixosModules/` and `homeManagerModules/`.

### Key Structural Rules:
1. **No `default.nix` Files**: There are no `default.nix` files in category directories. `import-tree` scans all `.nix` files recursively automatically.
2. **Automatic Inclusion**: To add a new system or user configuration, simply create a dedicated `.nix` file inside the appropriate directory and stage it in Git (`git add <file>`).
3. **Flake Entrypoint Resolution**:
   - `flake.nix` includes `(inputs.import-tree ./nixosModules)` in `nixosSystem.modules`.
   - `nixosModules/core/home-manager.nix` includes `(inputs.import-tree ../../homeManagerModules)` in `home-manager.users.aleks.imports`.

---

## Profile Entrypoints vs. Category Modules

### 1. Minimal Entrypoints (`host/`)
- `host/configuration.nix`: Minimal NixOS system profile entrypoint.
- `host/home.nix`: Minimal Home Manager user profile entrypoint.
- **Rule**: Entrypoints specify baseline metadata (`system.stateVersion`, `home.username`) and minimal host overrides. They must not hold raw package definitions or inline configuration blocks.

---

## 2. System-wide Modules (`nixosModules/`)

Loaded automatically via `(inputs.import-tree ./nixosModules)`:

- `core/`: Core OS settings (locale, timezone, user accounts, system-wide packages, security policies, Home Manager integration).
- `hardware/`: Physical hardware configs (bootloader, kernel modules, audio/pipewire, bluetooth, power management/TLP).
- `services/`: Background daemons & system services (networking, display managers/greeter, virtualization, printing).
- `programs/`: System-level GUI and gaming applications requiring root capabilities or system-wide wrappers (e.g., Hyprland system integration).

---

## 3. User-space Modules (`homeManagerModules/`)

Loaded automatically via `(inputs.import-tree ../../homeManagerModules)` inside `nixosModules/core/home-manager.nix`:

- `cli/`: Shell configurations (zsh, bash, starship), git, ssh, tmux, and CLI developer tools.
- `desktop/`: Hyprland compositing, Waybar, Noctalia, wallpaper daemon, notification daemons, app launchers (Walker, Wofi), and symlink manager (`symlinks.nix`).
- `programs/`: User-space GUI applications (browsers like Zen/Brave, text editors like Neovim, media players like mpv, yazi file manager).
- `system/`: User system libraries, unstable channel overlays, and manual home environment settings.

---

## 4. Module Conventions

1. **File-based Splitting**: Split configurations into dedicated files (e.g. `nixosModules/hardware/audio.nix`). No manual registration in `imports = [ ... ]` is needed thanks to `import-tree`.
2. **Self-Contained Bundling**: Keep daemon settings, systemd service overrides, and required packages together in the same module file.
