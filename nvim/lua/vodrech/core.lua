-- Core methods

local create_command = vim.api.nvim_create_autocmd
local run_function = vim.api.nvim_command

-- Create command that runs on packer.lua --> PackerStatus
-- create_command(
-- 	{"FileType"},
-- 	{
-- 		pattern = {"lua"},
-- 		callback = function ()
-- 			run_function("PackerStatus")
-- 		end,
-- 		group = "user-config"
-- 	}
-- )
