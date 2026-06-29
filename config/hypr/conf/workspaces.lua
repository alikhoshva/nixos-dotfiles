--------------------
---- WORKSPACES ----
--------------------

-- See https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Workspaces 1-5 on External Monitor (HDMI-A-1)
        for i = 1, 5 do
            hl.workspace_rule({
                workspace  = tostring(i),
                monitor    = "HDMI-A-1",
            })
        end

    -- Workspaces 6-10 on Laptop Display (eDP-1)
    for i = 6, 10 do
        hl.workspace_rule({
            workspace  = tostring(i),
            monitor    = "eDP-1",
        })
    end
