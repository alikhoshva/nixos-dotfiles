-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:

hl.on("hyprland.start", function () 
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("noctalia-shell")
    hl.exec_cmd("hyprctl setcursor Catppuccin-Mocha-Light-Cursors 24")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("bash -c 'elephant & sleep 2 && walker --gapplication-service'")
end)
