# NixOS & Home Manager Configuration

A clean, modular NixOS and Home Manager configuration built from scratch using Nix Flakes, Lix, and managed via the `nh` (Nix Helper) CLI tool.

---

## Repository Structure

The configuration is split into distinct logical boundaries to keep things modular, easy to expand, and simple to maintain:

```
nixos-dotfiles/
├── .github/workflows/            # CI/CD: Automated builds & weekly scheduled updates
│   └── auto-update.yml           # Scheduled weekly updater pushing to dev branch & Cachix
│
├── host/                         # Minimal entrypoints
│   ├── configuration.nix         # Minimal NixOS system profile entrypoint
│   ├── hardware-configuration.nix # Auto-generated hardware scan results
│   └── home.nix                  # Minimal Home Manager user profile entrypoint
│
├── nixosModules/                 # System-wide NixOS configurations (via inputs.import-tree)
│   ├── core/                     # Core settings (locale, users, security, Lix, Cachix)
│   ├── hardware/                 # Hardware configurations (boot, audio, bluetooth, power)
│   ├── services/                 # Background system services (networking, portals, syncthing)
│   └── programs/                 # System-level GUI & gaming applications
│
├── homeManagerModules/           # User-space configurations (via inputs.import-tree)
│   ├── cli/                      # CLI tools, bash aliases, nh, fzf, languages
│   ├── desktop/                  # Hyprland, Waybar, Noctalia, Walker, styling
│   ├── programs/                 # User GUI applications (Zen, VS Code, Spicetify, GUI tools)
│   └── system/                   # User system libraries, latest packages, wrappers
│
├── config/                       # Raw dotfiles (linked via out-of-store symlinks)
│   ├── kitty/, waybar/, hypr/, yazi/, starship/, walker/, etc.
│
└── .agents/                      # AI Agent guidelines, architecture memory, skills & scripts
```

---

## Daily Workflow & Shell Aliases

Convenient shell aliases are configured in `homeManagerModules/cli/shell.nix`:

| Command | Action |
| :--- | :--- |
| **`up`** | Pull current branch updates and apply switch instantly via Cachix (`nh os switch`) |
| **`up-dev`** | Switch to the automated `dev` branch, pull weekly pre-built updates, and switch |
| **`up-main`** | Switch back to the stable `main` branch and apply |

---

## Dual-Branch GitOps Architecture

To ensure your desktop remains 100% stable while staying up-to-date with cutting-edge rolling packages:

* **`main` Branch (Stable Base)**:
  * Manually curated and protected from direct automated changes.
  * Always known-good and rock-solid.
* **`dev` Branch (Automated Rolling Updates)**:
  * Every Sunday at 04:00 UTC (Midnight EDT), GitHub Actions runs `nix flake update`, verifies the build, pushes pre-compiled packages to `aleks-nixos-cache.cachix.org`, and pushes the verified `flake.lock` to `dev`.
  * If upstream packages fail to build, CI aborts and leaves both branches untouched.

### Promoting Dev to Main
Once you have tested `dev` and confirmed everything works smoothly:
```bash
git checkout main
git merge dev
git push
```

---

## Binary Caching & Security

* **Zero 3rd-Party Substituters**: To prevent binary cache poisoning / supply-chain vulnerabilities, the system trusts only official `cache.nixos.org` and your personal `aleks-nixos-cache.cachix.org`.
* **CI Cloud Builder**: Heavy compilation (e.g. Zen Browser, Walker, Electron apps, Tree-sitter parsers) is offloaded to GitHub Actions CI and signed with your personal token. Local machine rebuilds download binary artifacts in seconds.

---

## Development & Testing

Always verify your configuration compiles cleanly before applying:

1. **Syntax and type check**:
   ```bash
   nix flake check
   ```

2. **Unified evaluation & dry-build**:
   ```bash
   nh os switch --dry
   ```

3. **Run AI Agent Verification Script**:
   ```bash
   .agents/scripts/verify.sh
   ```
