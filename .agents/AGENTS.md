# AI Coding Agent Guidelines (`.agents/AGENTS.md`)

Welcome! This repository contains a clean, modular NixOS and Home Manager setup using Nix Flakes and the `nh` (Nix Helper) CLI.

---

## 1. Repository Map

```
nixos-dotfiles/
├── host/                         # Minimal entrypoints (configuration.nix, home.nix)
├── nixosModules/                 # System NixOS configurations (core, hardware, services, programs)
├── homeManagerModules/           # User space configurations (cli, desktop, programs, system)
├── config/                       # Raw dotfiles (Hyprland, Waybar, Noctalia, Kitty, etc.)
└── .agents/                      # Agent architecture (skills, knowledge, scripts, logs)
```
*(For deep architecture & dotfile mappings, see [.agents/knowledge/nix-architecture.md](file:///.agents/knowledge/nix-architecture.md) and [.agents/knowledge/dotfiles-matrix.md](file:///.agents/knowledge/dotfiles-matrix.md)).*

---

## 2. Core Invariant Rules

1. **Minimal Entrypoints**: `host/configuration.nix` and `host/home.nix` are strictly minimal entrypoints containing metadata and category imports. Do **not** put raw packages or inline configs here.
2. **Dynamic Tree Importing**: All modules inside `nixosModules/` and `homeManagerModules/` are dynamically imported via `inputs.import-tree`. Do not write `default.nix` files; simply add dedicated Nix files (e.g. `nixosModules/hardware/audio.nix`) and stage them with Git (`git add`). Avoid complex `options` schemas unless multi-host is requested.
3. **Self-Contained Bundling**: Keep related components (daemons, packages, dotfiles) bundled together within their dedicated module.
4. **Git Staging Requirement**: Nix Flakes ignore untracked Git files. Always stage new files (`git add <file>`) before running Nix evaluation or build commands.
5. **Zero Redundancy / Anti-Bloat**: Do not set Nix options to implicit defaults (`enable = false;`, `extraConfig = "";`, `settings = {};`). Do not list packages in `home.packages` if an active module already provides them.

---

## 3. Communication & Token Hygiene

- **Zero Conversational Filler**: Omit preambles (*"Sure, I'd be happy to help!"*) and postscripts (*"Let me know if you need anything else!"*). Present high-density bullet points and direct code actions.
- **Targeted Line Ranges**: Use line range parameters (`StartLine`/`EndLine`) when viewing large files. Output only modified diffs in responses, never entire 500+ line files.
- **Log Offloading**: Run `.agents/scripts/verify.sh` to test changes. Output is filtered automatically to keep context tokens low.

---

## 4. Skills & Workflow Routing

- **Module Editing**: Activate `nix-module-workflow` ([.agents/skills/nix-module-workflow/SKILL.md](file:///.agents/skills/nix-module-workflow/SKILL.md)).
- **Anti-Bloat Checklist**: Activate `nix-anti-bloat` ([.agents/skills/nix-anti-bloat/SKILL.md](file:///.agents/skills/nix-anti-bloat/SKILL.md)).
- **Desktop Dotfiles**: Activate `dotfiles-symlink-manager` ([.agents/skills/dotfiles-symlink-manager/SKILL.md](file:///.agents/skills/dotfiles-symlink-manager/SKILL.md)).
- **Verification & Testing**: Run `.agents/scripts/verify.sh` (or activate `nix-verification` skill).
- **Debugging & Errors**: Activate `systematic-debugging` ([.agents/skills/systematic-debugging/SKILL.md](file:///.agents/skills/systematic-debugging/SKILL.md)).
- **Git Operations**: Activate `git-atomic-workflow` ([.agents/skills/git-atomic-workflow/SKILL.md](file:///.agents/skills/git-atomic-workflow/SKILL.md)).
