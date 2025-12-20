-- Default remaps
--
local opts = { noremap = false, silent = true } -- options
local term_opts = { silent = true } -- does not print the action
local keymap = vim.api.nvim_set_keymap -- calling of the nvim function

-- OPTIONS
local notification_type = "info"

-- Buffer Navigation
keymap("n", "<C-Right>", ":wincmd l<cr>", opts)
keymap("n", "<C-Left>", ":wincmd h<cr>", opts)
keymap("n", "<C-Up>", ":wincmd k<cr>", opts)
keymap("n", "<C-Down>", ":wincmd j<cr>", opts)

-- TAB Navigation
keymap("n", "<TAB>", ":tabprev<cr>", opts) -- Previous Tab
keymap("n", "<S-Tab>", ":tabnext<cr>", opts)
keymap("n", "<leader><tab>", ":tabclose<cr>", opts)

if vim.g.essential_variables then
	if vim.g.system == "Windows" then
		-- Script Folder
		local script_exec = os.getenv("USERPROFILE") .. "\\scripts\\start.ps1"
		local script_env_exec = os.getenv("USERPROFILE") .. "\\scripts\\environment.ps1"
		keymap(
			"n",
			"<leader>cs",
			":sp TERMINAL | wincmd J | resize10 | term powershell " .. script_exec .. "<cr>",
			opts
		)
		keymap(
			"n",
			"<leader>cs",
			":sp TERMINAL | wincmd J | resize10 | term powershell " .. script_env_exec .. "<cr>",
			opts
		)
	end
else
	keymap(
		"n",
		"<leader>cs",
		":lua vim.notify('keymap not working cause vim.g.essential_variables = "
			.. tostring(vim.g.essential_variables)
			.. "'"
			.. ","
			.. notification_type
			.. ")<cr>",
		opts
	)
end

-- Sourcing
keymap("n", "<leader><leader>s", ":so %<cr>", opts) -- Sourcing current file

-- DEFAULT Keymap <commented>
-- <C-w> + (v or s) split the view
-- Escape :terminal --> <C-\n>

-- @@ PLUGINS $$ --

-- Oil
keymap("n", "<leader>t", ":Oil<cr>", opts)

-- Telescope
keymap("n", "<leader>bb", ":Telescope buffers<cr>", opts)
keymap("n", "<leader>ff", ":Telescope find_files<cr>", opts)
keymap("n", "<leader>d", ":Telescope diagnostics<cr>", opts)

-- Heartbeat
keymap("n", "<leader>hb", ":Heartbeat<cr>", opts)
