-- Hyprland Monitor Module
-- See https://wiki.hypr.land/Configuring/Basics/Monitors/

local M = {}

function M.setup()
	hl.monitor({
		output = "DP-2",
		mode = "1920x1080@60",
		position = "0x0",
		scale = "1",
	})
	hl.monitor({
		output = "HDMI-A-1",
		mode = "2560x1440@144@144",
		position = "1920x0",
		scale = "1",
	})
	hl.monitor({
		output = "HDMI-A-2",
		mode = "preferred",
		position = "1920x1440",
		scale = "1",
	})

	-- Window Rules
	hl.workspace_rule({
		workspace = "1",
		monitor = "HDMI-A-1"
	})
	hl.workspace_rule({
		workspace = "2",
		monitor = "DP-2"
	})
	hl.workspace_rule({
		workspace = "3",
		monitor = "HDMI-A-1"
	})
	hl.workspace_rule({
		workspace = "4",
		monitor = "DP-2"
	})

	hl.window_rule({
    match = {
        class = "discord",
    },
    workspace = "2",
	})
	hl.window_rule({
    match = {
        class = "bolt-launcher",
    },
    workspace = "4",
	})
end

return M

