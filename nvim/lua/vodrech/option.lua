-- User Option Configurations
-- NOTE* Use the 'user-config' au group or the same one created in the ~../usr/init.lua file

local options = {
	mouse = "a",
	cursorline = true,
	termguicolors = true,
	guifont = "monospace:h17", -- Emojis
	number = true, -- Linenumbers
	list = true,
	scrolloff = 999, -- Keeps cursor in the middle
	relativenumber = true, -- Linenumbers gets relative to current pos
	colorcolumn = '80',
	showtabline = 2,
	showmode = false, -- Lualine shows this anyway
}

for k,v in pairs(options) do
	vim.opt[k] = v
end
