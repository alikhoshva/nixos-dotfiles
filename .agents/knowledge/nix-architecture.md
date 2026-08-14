# NixOS & Home Manager Architecture Guide

This document serves as institutional memory for the system layout, module hierarchy, CI/CD pipeline, and design philosophy of `nixos-dotfiles`.

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

- `core/`: Core OS settings (locale, timezone, user accounts, system-wide packages, security policies, Lix, personal Cachix substituter).
- `hardware/`: Physical hardware configs (bootloader, kernel modules, audio/pipewire, bluetooth, power management/TLP).
- `services/`: Background daemons & system services (networking, portals, syncthing, virtualization, printing).
- `programs/`: System-level GUI and gaming applications requiring root capabilities or system-wide wrappers (e.g., Hyprland system integration, Noctalia).

---

## 3. User-space Modules (`homeManagerModules/`)

Loaded automatically via `(inputs.import-tree ../../homeManagerModules)` inside `nixosModules/core/home-manager.nix`:

- `cli/`: Shell configurations (bash aliases, starship, nh), git, ssh, fzf, and CLI developer tools.
- `desktop/`: Hyprland compositing, Waybar, Noctalia, wallpaper daemon, notification daemons, app launchers (Walker), and symlinks.
- `programs/`: User-space GUI applications (Zen Browser, VS Code, Spicetify, GUI tools).
- `system/`: User system libraries, latest packages (`pkgs.unstable`), and wrapper scripts.

---

## 4. CI/CD & Personal Binary Caching Architecture

To prevent supply-chain vulnerabilities from 3rd-party binary caches while avoiding long local compilations:

1. **Personal Cache (`aleks-nixos-cache.cachix.org`)**:
   - Only `cache.nixos.org` and `aleks-nixos-cache.cachix.org` are trusted in `nixosModules/services/cachix/aleks-nixos-cache.nix`.
2. **GitHub Actions Workflow**:
   - `.github/workflows/auto-update.yml`: Runs exclusively on a weekly schedule (Sunday 04:00 UTC) or manual dispatch. It updates `flake.lock`, builds toplevel, pushes binaries to `aleks-nixos-cache`, and commits verified lockfiles to the `dev` branch. Does NOT trigger on regular local git pushes.
3. **Branching Model**:
   - `main`: Stable, curated base.
   - `dev`: Weekly rolling updates.
4. **Shell Aliases (`homeManagerModules/cli/shell.nix`)**:
   - `up`: `git -C ~/nixos-dotfiles pull && nh os switch`
   - `up-dev`: `git -C ~/nixos-dotfiles checkout dev && git -C ~/nixos-dotfiles pull && nh os switch`
   - `up-main`: `git -C ~/nixos-dotfiles checkout main && git -C ~/nixos-dotfiles pull && nh os switch`
