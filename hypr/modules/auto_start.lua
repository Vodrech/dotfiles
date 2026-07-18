-- Keybinds Module
-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

local M = {}

function M.setup()
	print("Auto Start Module Loaded")
	hl.on("hyprland.start", function()
		hl.exec_cmd("elephant & walker --gapplication-service & waybar")
		hl.exec_cmd("sleep 1 && awww-daemon")
	end)
end

return M
