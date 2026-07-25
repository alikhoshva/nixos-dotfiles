# NixOS & Home Manager Configuration

A clean, modular NixOS and Home Manager configuration built from scratch using Nix Flakes and managed via the `nh` (Nix Helper) CLI tool.

## Repository Structure

The configuration is split into distinct logical boundaries to keep things modular, easy to expand, and simple to maintain:

```
nixos-dotfiles/
├── host/
│   ├── configuration.nix         # Minimal NixOS system profile entrypoint
│   ├── hardware-configuration.nix # Auto-generated hardware scan results
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
└── config/                       # Raw dotfiles (linked via Home Manager symlinks)
    ├── kitty/, waybar/, wofi/, hypr/, yazi/, starship/, etc.
```

---

## How to Apply Changes

System and Home Manager configurations are fully unified into a single NixOS flake output (`nixosConfigurations.nixos`). All changes (both system-wide and user-space dotfiles/apps) are built and applied together using `nh`.

### Rebuilding the Unified Configuration
To build and apply all system and Home Manager settings in one command:
```bash
nh os switch
```
*Behind the scenes, `nixosModules/core/home-manager.nix` integrates Home Manager directly into the `nixos` system evaluation.*

---

## Development & Testing (Safely checking your changes)

Always verify your configuration compiles correctly before applying it:

1. **Flake syntax and type check**:
   ```bash
   nix flake check
   ```

2. **Unified evaluation & dry-build**:
   ```bash
   nh os switch --dry
   ```
   *This evaluates both NixOS and Home Manager configurations to verify there are no syntax or type errors.*

3. **Branch workflow**:
   Make complex refactors or additions on a separate Git branch first. Only merge to `main` when the dry-run succeeds!
