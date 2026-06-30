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

Both system and home environment modifications are managed using the modern `nh` tool.

### 1. Rebuilding the NixOS System Configuration
To build and apply system-wide settings (e.g. bootloader, system packages, NixOS services):
```bash
nh os switch
```
*Behind the scenes, this will build the configuration target defined under `nixosConfigurations` in `flake.nix`.*

### 2. Rebuilding the Home Manager Configuration
To build and apply user-specific settings (e.g. dotfiles, shell aliases, user applications, themes):
```bash
nh home switch
```
*Behind the scenes, this will build the user profile defined under `homeConfigurations` in `flake.nix`.*

---

## Development & Testing (Safely checking your changes)

Always verify your configuration compiles correctly before applying it:

1. **Flake syntax and type check**:
   ```bash
   nix flake check
   ```

2. **System dry-build (verify evaluation without applying)**:
   ```bash
   nh os switch --dry
   ```

3. **Home Manager dry-build**:
   ```bash
   nh home switch --dry
   ```

4. **Branch workflow**:
   Make complex refactors or additions on a separate Git branch first. Only merge to `main` when the dry-run succeeds!
