------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1200@60",
    position = "0x0",
    scale    = 1,
})

hl.monitor({
    output   = "HDMI-A-1",
    mode     = "3840x2160@120",
    position = "1920x0",
    scale    = 1.5,
    vrr      = 1,
})

-- Fallback monitor rule for any other connected display
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = 1,
})

hl.config({
    xwayland = {
        force_zero_scaling = true,
    }
})

