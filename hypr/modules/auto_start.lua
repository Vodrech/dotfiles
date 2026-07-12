-- Auto Start Module
-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

local M = {}

function M.setup()
	hl.on("hyprland.start", function()
		hl.exec_cmd("waybar")
	end)
end

return M
