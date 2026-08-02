-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

-- QT & DPI Scaling
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "gtk3")
hl.env("QT_STYLE_OVERRIDE", "gtk3")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "0")
hl.env("QT_ENABLE_HIGHDPI_SCALING", "1")
hl.env("QT_SCALE_FACTOR_ROUNDING_POLICY", "PassThrough")
hl.env("XFT_DPI", "96")

-- Disable appimage launcher by default
hl.env("APPIMAGELAUNCHER_DISABLE", "1")

-- Cursor
hl.env("HYPRCURSOR_THEME", "catppuccin-mocha-light-cursors")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "catppuccin-mocha-light-cursors")
hl.env("XCURSOR_SIZE", "24")

-- SSH Agent (GCR Keyring)
hl.env("SSH_AUTH_SOCK", (os.getenv("XDG_RUNTIME_DIR") or "/run/user/1000") .. "/gcr/ssh")
