-- KEYBINDINGS
-- S = Shift | <S-p> --> Shift + p
-- C = Ctrl |  <C-p> --> Ctrl + p
-- <Space> = Space
-- <cr> = Carriage return = Enter

local opts = { noremap = false , silent = true }  -- options
local term_opts = { silent = true } -- does not print the action
local keymap = vim.api.nvim_set_keymap -- calling of the nvim function

-- PLUGINS
local movement = {
	opts = {noremap = false, silent},
	buffer_left = {value = keymap("n", "<C-Left>", ":wincmd h<cr>", opts)},
}

-- Sourcing the snippets
keymap("n", "<leader><leader>s",":lua require('after.plugin.utils.completion')<cr>",opts)

-- DEFAULT Keymap <commented>
-- <C-w> + (v or s) split the view
-- Escape :terminal --> <C-\n>

-- Termination
keymap("n", "<leader>qq", ":q<cr>", opts)

-- TAB Navigation
keymap("n", "<TAB>", ":tabprev<cr>", opts)  -- Previous Tab
keymap("n", "<S-Tab>", ":tabnext<cr>", opts)
keymap("n", "<leader><tab>", ":tabclose<cr>", opts)

-- Buffer Navigation
keymap("n", "<C-Right>", ":wincmd l<cr>", opts)
keymap("n", "<C-Left>", ":wincmd h<cr>", opts)
keymap("n", "<C-Up>", ":wincmd k<cr>", opts)
keymap("n", "<C-Down>", ":wincmd j<cr>", opts)

-- @@ PLUGINS $$ --

-- Neotree
keymap("n", "<leader>t", ":NeoTreeShow<cr>", opts)

-- Zenmode
keymap("n", "<leader>z", ":ZenMode<cr>", opts)

-- Telescope
keymap("n", "<leader>bb", ":Telescope buffers<cr>", opts)

-- AutoSessions
keymap("n", "<leader>r", ":lua require(\"auto-session.session-lens\").search_session()<cr>", { noremap = true})


-- Harpoon
keymap("n", "<leader>h", ":lua require(\"harpoon.ui\").toggle_quick_menu()<cr>", opts) -- Shows harpoon menu
keymap("n", "<leader>sh", ":lua require(\"harpoon.mark\").add_file()<cr>", opts) -- Save's file to harpoon

-- Heartbeat
keymap("n","<leader>hb", ":Heartbeat<cr>", opts)
