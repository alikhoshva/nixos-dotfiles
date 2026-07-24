---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local terminal    = "kitty"
local fileManager = "thunar"
--local menu        = 'bash -c "pkill wofi; wofi --show drun --conf ~/.config/wofi/config.conf --style ~/.config/wofi/style.css"'
local menu        = "walker"
local browser     = "zen-twilight"
local editor      = "code"

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Actions
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q",      hl.dsp.window.close())
hl.bind(mainMod .. " + M",      hl.dsp.exit())
hl.bind(mainMod .. " + E",      hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + T",      hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F",      hl.dsp.exec_cmd("hyprctl dispatch fullscreen"))
hl.bind(mainMod .. " + SPACE",  hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P",      hl.dsp.window.pseudo())
hl.bind(mainMod .. " + B",      hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + C",      hl.dsp.exec_cmd(editor))

-- Scripts / Tools
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("bash /home/aleks/.config/scripts/wallpaper.sh"))
hl.bind(mainMod .. " + SHIFT + D", hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | tee \"$HOME/Media/Pictures/Screenshots/$(date +'%Y-%m-%d-%H%M%S_grim.png')\" | wl-copy && notify-send \"Screenshot Snipped\" \"Saved to Pictures and copied to clipboard.\""))

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("bash /home/aleks/.config/scripts/toggle-mic.sh"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- Move focus
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))

-- Swap window
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.swap({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.swap({ direction = "d" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.swap({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.swap({ direction = "r" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Monitor Management
-- External 4K Desktop Mode.
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd("~/.config/scripts/desktop_4k.sh"))

-- External 1080p Game Mode.
hl.bind(mainMod .. " + G", hl.dsp.exec_cmd("~/.config/scripts/gamemode_1080p.sh"))

-- Laptop only. Disable external FIRST.
hl.bind(mainMod .. " + SHIFT + O", hl.dsp.exec_cmd([[hyprctl eval 'hl.monitor({ output = "HDMI-A-1", disabled = true }) hl.monitor({ output = "eDP-1", mode = "1920x1200@60", position = "0x0", scale = 1, disabled = false })']]))

-- Reset both side-by-side (no overlap)
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd([[hyprctl eval 'hl.monitor({ output = "eDP-1", mode = "1920x1200@60", position = "0x0", scale = 1, disabled = false }) hl.monitor({ output = "HDMI-A-1", mode = "3840x2160@120", position = "1920x0", scale = 1, disabled = false })']]))
