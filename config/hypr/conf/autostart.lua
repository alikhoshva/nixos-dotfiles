-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:

hl.on("hyprland.start", function () 
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user start hyprland-session.target")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("noctalia-shell")
    hl.exec_cmd("hypridle")
end)

hl.on("hyprland.shutdown", function ()
    os.execute("systemctl --user stop hyprland-session.target && sleep 0.1")
end)
