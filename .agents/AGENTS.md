# AI Coding Agent Guidelines (`.agents/AGENTS.md`)

Welcome! This repository contains a clean, modular NixOS and Home Manager setup using Nix Flakes and the `nh` (Nix Helper) CLI.

---

## 1. Repository Structure & Map

```
nixos-dotfiles/
├── host/                         # Minimal entrypoints (configuration.nix, home.nix)
├── nixosModules/                 # System NixOS configurations (core, hardware, services, programs)
├── homeManagerModules/           # User space configurations (cli, desktop, programs, system)
├── config/                       # Raw dotfiles (Hyprland, Waybar, Noctalia, Kitty, etc.)
└── .agents/                      # Agent architecture (skills, knowledge, scripts, logs)
```
*(For deep architectural breakdown and dotfile mappings, see [.agents/knowledge/nix-architecture.md](file:///.agents/knowledge/nix-architecture.md) and [.agents/knowledge/dotfiles-matrix.md](file:///.agents/knowledge/dotfiles-matrix.md)).*

---

## 2. Core Invariant Rules

1. **Minimal Entrypoints**: `host/configuration.nix` and `host/home.nix` are strictly minimal entrypoints containing metadata and category imports. Do **not** put raw packages or inline configs here.
2. **Dynamic Tree Importing**: All modules inside `nixosModules/` and `homeManagerModules/` are dynamically imported via `inputs.import-tree`. Do not write `default.nix` files; simply add dedicated Nix files (e.g. `nixosModules/hardware/audio.nix`) and stage them with Git (`git add`). Avoid complex `options` schemas unless multi-host is requested.
3. **Self-Contained Bundling**: Keep related components (daemons, packages, dotfiles) bundled together within their dedicated module.
4. **Git Staging Requirement**: Nix Flakes ignore untracked Git files. Always stage new files (`git add <file>`) before running Nix evaluation or build commands.

---

## 3. Workflow & Verification Entrypoints

- **Module Editing**: When creating or editing modules, activate the `nix-module-workflow` skill ([.agents/skills/nix-module-workflow/SKILL.md](file:///.agents/skills/nix-module-workflow/SKILL.md)).
- **Desktop Dotfiles**: When editing desktop dotfiles under `config/`, activate the `dotfiles-symlink-manager` skill ([.agents/skills/dotfiles-symlink-manager/SKILL.md](file:///.agents/skills/dotfiles-symlink-manager/SKILL.md)).
- **Verification & Testing**: Never report success without testing. Execute the fast, log-filtered verification script:
  ```bash
  .agents/scripts/verify.sh
  ```
  *(Full output is logged to `.agents/logs/last_verify.log`; stdout outputs concise success or filtered error traces).*
