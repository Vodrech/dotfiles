-- Hyprland Inputs Module
--
local M = {}
function M.setup()
	hl.config({
			input = {
					kb_layout  = "us,us,se",
					kb_variant = ",colemak",
					kb_model   = "",
					kb_options = "",
					kb_rules   = "",

					follow_mouse = 1,

					sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

					touchpad = {
							natural_scroll = false,
					},
			},
	})
end
return M
