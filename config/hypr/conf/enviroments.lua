-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

-- QT Platform
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "gtk3")
hl.env("QT_STYLE_OVERRIDE", "gtk3")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")

-- Ozone / Native Wayland for Electron & Chromium
hl.env("NIXOS_OZONE_WL", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("OZONE_PLATFORM", "wayland")

-- Disable appimage launcher by default
hl.env("APPIMAGELAUNCHER_DISABLE", "1")

-- Cursor
hl.env("HYPRCURSOR_THEME", "catppuccin-mocha-light-cursors")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "catppuccin-mocha-light-cursors")
hl.env("XCURSOR_SIZE", "24")

-- SSH Agent (GCR Keyring)
hl.env("SSH_AUTH_SOCK", (os.getenv("XDG_RUNTIME_DIR") or "/run/user/1000") .. "/gcr/ssh")
