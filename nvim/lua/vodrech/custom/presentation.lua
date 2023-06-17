local create_command = vim.api.nvim_create_autocmd -- Creates a new autocmd command

-- Options to not show any output on commands
local opts = { noremap = false , silent = true }  -- options
create_command(
	{"FileType"}, 
	{pattern = {"vim_presentation_mode"},
	callback = function()
		vim.api.nvim_create_autocmd({"BufNewFile", "BufRead", "BufEnter"},{
		callback = function()
			vim.api.nvim_buf_set_keymap(0, "n", "<Right>", ":bnext<cr>", opts)
			vim.api.nvim_buf_set_keymap(0, "n", "<Left>", ":bprev<cr>", opts)
			-- vim.api.nvim_set_keymap("n", "<Left>", ":bprev<cr>", opts)
		end,
		buffer = 0})
	end,
	group = presentation_group,
	desc = "Enables the presentation mode, with remaps functions etc for .vpm filetypes"
	}
)
