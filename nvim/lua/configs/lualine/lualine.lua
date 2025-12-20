-- Main lua file for lualine
-- Loading helping tables for setting the lualine
local lualine = require("lualine")
local functions = require("configs.lualine.functions")

local config = {
	options = {
		always_divide_middle = true,
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		theme = "gruvbox",
		globalstatus = true,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
		},
	},
	sections = {
		lualine_a = { functions.mode_component },
		lualine_b = { functions.current_directory, functions.changed_component },
		lualine_c = {},
		lualine_x = { "diagnostics", "diff", "branch" },
		lualine_y = { functions.lsp_client_component },
		lualine_z = { functions.develop_environment_component },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	winbar = {},
	inactive_winbar = {},
}

lualine.setup(config)
