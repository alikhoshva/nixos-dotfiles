# Nix Defaults & Anti-Patterns Reference

This document serves as institutional memory detailing standard default option values in NixOS and Home Manager, along with anti-patterns to avoid for clean, minimal codebase maintenance.

---

## Implicit Defaults (Do Not Set Explicitly)

Setting options to their implicit default values creates code bloat and adds zero functional value. Avoid writing lines like:

1. **`enable = false;`**:
   - NixOS & Home Manager modules are disabled by default. Do not add `enable = false;` unless toggling an option that defaults to `true` (e.g. `services.xserver.enable`).

2. **Empty Attribute Sets & Strings**:
   - `extraConfig = "";`
   - `settings = {};`
   - `packages = [];`

3. **Redundant Package Additions**:
   - Avoid adding binary packages to `environment.systemPackages` or `home.packages` when an activated module already installs them.
   - *Bad*: `programs.git.enable = true;` plus `home.packages = [ pkgs.git ];`.
   - *Good*: `programs.git.enable = true;` (automatically adds `pkgs.git`).

4. **Duplicate Pipewire & Audio Flags**:
   - `services.pipewire.enable = true;` automatically manages ALSA and PulseAudio emulation settings when configured. Do not set redundant disable flags for legacy audio systems unless resolving an explicit hardware conflict.

---

## Recommended Clean Nix Idioms

- Use **with-free syntax** or explicit `pkgs.` prefixes (`pkgs.git`, `pkgs.htop`) to prevent scope pollution.
- Group related options cleanly using attribute set syntax rather than repetitive prefixed paths.
- Keep entrypoints (`host/configuration.nix`, `host/home.nix`) strictly for host metadata and category imports.
