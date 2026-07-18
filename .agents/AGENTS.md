# AI Coding Agent Guidelines (AGENTS.md)

Welcome! This repository contains a clean, modular NixOS and Home Manager setup using Nix Flakes and the `nh` (Nix Helper) CLI. 

To maintain the cleanliness and design of this codebase, you must follow the rules and guidelines detailed below.

---

## 1. Repository Structure & Directory Map

Before making edits, locate the proper place for your changes:

```
nixos-dotfiles/
├── host/
│   ├── configuration.nix         # Minimal NixOS system profile entrypoint
│   └── home.nix                  # Minimal Home Manager user profile entrypoint
│
├── nixosModules/                 # System-wide NixOS configurations
│   ├── default.nix               # Combines and imports all system categories
│   ├── core/                     # Core system settings (locale, users, core packages, security)
│   ├── hardware/                 # Hardware configurations (boot, audio, bluetooth, power management)
│   ├── services/                 # Background system services (networking, virtualization, printing)
│   └── programs/                 # System-level GUI & gaming applications
│
├── homeManagerModules/           # User-space configurations (Home Manager)
│   ├── default.nix               # Combines and imports all user categories
│   ├── cli/                      # CLI tools, shells, git/ssh configs, and developer helpers
│   ├── desktop/                  # Desktop environment styling, themes, app launchers, and symlinks
│   ├── programs/                 # User GUI applications (browsers, editors, media players)
│   └── system/                   # User system libraries, unstable packages, and manual settings
│
└── config/                       # Raw dotfiles
    └── (Waybar, Hyprland, etc. symlinked to ~/.config/ via homeManagerModules/desktop/symlinks.nix)
```

---

## 2. Coding Guidelines & Philosophy

### Keep Profiles Minimal
- `host/configuration.nix` and `host/home.nix` are **strictly minimal entrypoints**. 
- They must only contain profile metadata (e.g. `system.stateVersion`, `home.username`) and imports of category default modules. Do **not** write raw packages, aliases, or service configuration inside them.

### Lean Module Philosophy (No Options Boilerplate)
- Avoid defining complex Nix options schemas (i.e. `options` and `lib.mkIf config.xxx.enable`) unless the user explicitly requests support for multi-host setups.
- Use **file-based module splitting** instead. Simply group settings into dedicated Nix files (e.g. `nixosModules/hardware/audio.nix`) and add them to their parent `default.nix` imports.

### Self-Contained Dependency Bundling
- When adding a tool or background daemon, keep all related components together.
- *Example*: Bundle the `tuigreet` package in `services/greeter.nix` alongside the `services.greetd` settings, rather than spreading packages across a global `environment.systemPackages` list.

---

## 3. Mandatory Development Workflow

### 1. Stage New Files Immediately
Nix Flakes are Git-aware and will ignore files that are not tracked. When you create new files, you **MUST** run:
```bash
git add <newfile>  # or git add .
```
before running any nix commands, otherwise Nix will throw an "uncommitted/no file found" error.

### 2. Mandatory Local Verification
Do not report success or ask the user to switch configurations without testing your changes first. You must run:
- **Flake syntax evaluation**:
  ```bash
  nix flake check
  ```
- **System evaluation & link dry-run**:
  ```bash
  nh os switch --dry
  ```
- **Home Manager evaluation & link dry-run**:
  ```bash
  nh home switch --dry
  ```

### 3. Git Branching
- Perform all development tasks on a separate feature branch for significant changes (e.g. affecting more than 2 files). For minor edits (2 files or fewer), you may work directly on the `main` branch. Do not commit edits directly to `main` for large tasks.

---

## 4. Context & Token Optimization (Scan Efficiency)

To keep evaluations fast and context usage low, follow these guidelines:
- **Pinpoint, don't scan**: Use the modular directory map to target and open *only* the specific file relevant to the task (e.g., open `hardware/audio.nix` for sound problems).
- **Ignore unrelated configs**: If a file is named `tlp.nix` and the current task is unrelated to battery or power management, do **not** view or read it.
- **Avoid reading massive files**: Refrain from reading large configuration files (such as `noctalia.nix` which contains 600+ lines) unless the task explicitly requires editing them.
