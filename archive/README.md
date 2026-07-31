# Repository Archive Index

This directory stores inactive, legacy, or superseded configurations, scripts, and code modules preserved for reference. The directory structure mirrors the main repository hierarchy for ease of navigation and restoration.

---

## Repository Archive Structure

```
archive/
├── README.md                     # This manifest and restoration guide
├── config/                       # Raw user dotfiles & desktop scripts
│   ├── hypr/                     # Legacy Hyprland .conf files (superseded by Lua configs)
│   ├── scripts/                  # Deprecated / inactive desktop scripts
│   ├── waybar/                   # Legacy Waybar configuration (superseded by Noctalia)
│   └── wlogout/                  # Legacy Wlogout layout/style (superseded by Noctalia)
├── homeManagerModules/           # Archived Home Manager Nix modules
│   ├── anyrun.nix                # Legacy Anyrun launcher module (superseded by Walker/Wofi)
│   └── neovim.nix                # Legacy Neovim module
└── snippets.md                   # Archived flake input & Nix code snippets
```

---

## Catalog of Archived Items

| Archived Path | Original Path | Reason Archived | Date |
| :--- | :--- | :--- | :--- |
| `archive/config/waybar/` | `config/waybar/` | Superseded by Noctalia shell desktop bar | 2026-07-31 |
| `archive/config/wlogout/` | `config/wlogout/` | Superseded by Noctalia shell session launcher | 2026-07-31 |
| `archive/config/scripts/wallpaper2.sh` | `config/scripts/wallpaper2.sh` | Alternative unused wallpaper selector | 2026-07-31 |
| `archive/config/scripts/config-edit.sh` | `config/scripts/config-edit.sh` | Unreferenced GUI editing script | 2026-07-31 |
| `archive/config/scripts/nh.sh` | `config/scripts/nh.sh` | Superseded by standard `nh` Nix CLI | 2026-07-31 |
| `archive/config/scripts/nh-completion.bash` | `config/scripts/archive/...` | Legacy shell completion script | 2026-07-31 |
| `archive/config/scripts/reload-waybar.sh` | `config/scripts/reload-waybar.sh` | Unused legacy waybar reload helper | 2026-07-31 |
| `archive/config/scripts/start-rstudio.sh` | `config/scripts/start-rstudio.sh` | Unreferenced Docker RStudio container starter | 2026-07-31 |
| `archive/config/scripts/stop-rstudio.sh` | `config/scripts/stop-rstudio.sh` | Unreferenced Docker RStudio container stopper | 2026-07-31 |
| `archive/config/hypr/` | `config/hypr/*.conf` | Hyprland configuration migrated to Lua format | 2026-07-31 |
| `archive/homeManagerModules/anyrun.nix` | `homeManagerModules/desktop/anyrun.nix` | Superseded by Walker launcher | 2026-07-31 |
| `archive/homeManagerModules/neovim.nix` | `homeManagerModules/programs/neovim.nix` | Unused Neovim HM module | 2026-07-31 |

---

## How to Restore an Item

To restore any archived configuration or module back to active status:

1. Move the file or folder back to its target destination under `config/` or `homeManagerModules/`:
   ```bash
   mv archive/config/scripts/<script-name>.sh config/scripts/
   ```
2. If restoring a script or dotfile, register symlink or keybind references if required.
3. Stage changes with `git add <path>` so Nix Flakes pick up the file.
4. Verify with `.agents/scripts/verify.sh`.
