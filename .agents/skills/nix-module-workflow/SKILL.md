---
name: nix-module-workflow
description: Use when creating, modifying, or refactoring NixOS or Home Manager configuration modules.
---

# Nix Module Workflow Skill

Follow this workflow when adding or editing modules in `nixosModules/` or `homeManagerModules/`.

## Workflow Steps

1. **Identify Target Subcategory**:
   - System configurations: `nixosModules/{core,hardware,services,programs}/`
   - User space configurations: `homeManagerModules/{cli,desktop,programs,system}/`

2. **File-Based Module Creation**:
   - Create a dedicated file (e.g. `nixosModules/services/syncthing.nix`).
   - Keep entrypoints (`host/configuration.nix` and `host/home.nix`) minimal.

3. **Self-Contained Dependency Bundling**:
   - Package all related options, systemd services, packages, and environment settings inside the dedicated module file.

4. **Dynamic Discovery (No `default.nix` needed)**:
   - Modules are automatically discovered via `inputs.import-tree`. You do not need to register the file in any `default.nix` or `imports` list.

5. **Stage & Verify**:
   - Stage new files in Git (`git add <file>`).
   - Run `.agents/scripts/verify.sh` to check flake syntax and dry-run switch evaluation.
