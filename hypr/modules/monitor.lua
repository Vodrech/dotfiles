-- Hyprland Monitor Module
-- See https://wiki.hypr.land/Configuring/Basics/Monitors/

local M = {}

function M.setup()
	hl.monitor({
		output = "",
		mode = "",
		position = "",
		scale = "auto",
	})
end

return M

