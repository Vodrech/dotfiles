-- Auto Start Module
-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

local M = {}

function M.setup()
	print("Auto Start Module Loaded")
	hl.on("hyprland.start", function()
		hl.exec_cmd("elephant & walker --gapplication-service & aww-daemon & waybar")
	end)
end

return M
