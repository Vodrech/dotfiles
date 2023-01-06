-- User Option Configurations
-- NOTE* Use the 'user-config' au group or the same one created in the ~../usr/init.lua file

local create_command = vim.api.nvim_create_autocmd

-- Sets the options in a key,value format
local function set_options()
	local options = {
		mouse = "a",
		cursorline = true,
		termguicolors = true,
		guifont = "monospace:h17", -- Emojis
		number = true, -- Linenumbers
		list = true,
		relativenumber = true -- Linenumbers gets relative to current pos
	}

	-- For loop with key, value pairs
	for k,v in pairs(options) do
		vim.opt[k] = v
	end
end

-- @@ Callers @@
local status_ok, err = pcall(set_options) -- Protected call | :h lua_pcall()
if status_ok then
	create_command(
	{"FileType"},
	{
		pattern = {"lua"},
		command = "echo 'options loaded succesivly'",
		group = "user-config"
	}
	)	
end
