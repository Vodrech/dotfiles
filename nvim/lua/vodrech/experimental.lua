-- Vodrech experimental functions

local Events = {
	"BufNewFile",
	"BufRead",
	"BufReadPost",
	"BufReadCmd",
	"FileReadPre",
	"FileReadPost",
	"FileReadCmd",
	"FilterReadPre",
	"FilterReadPost",
	"BufWrite",
	"BufWritePre",
	"BufWriteCmd",
	"FileWritePre",
	"FileWritePost",
	"FileWriteCmd",
	"FileAppendPre",
	"FileAppendPost",
	"FileAppendCmd",
	"FilterWritePre",
	"FilterWritePos",
}
-- vim.api.nvim_create_autocommand("BufEnter", "test.lua", "echo 'Hello'")

local create_autocmd = vim.api.nvim_create_autocmd

--create_autocmd({"FileType"}, {
--	group = "vodrech",
--	pattern = {"lua"},
--	callback = function()
--		vim.notify("Loaded lua file")
--	end,
--})
