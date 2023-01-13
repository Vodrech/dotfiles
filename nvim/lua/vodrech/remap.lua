-- KEYBINDINGS
-- S = Shift | <S-p> --> Shift + p
-- C = Ctrl |  <C-p> --> Ctrl + p
-- <Space> = Space
-- <cr> = Carriage return = Enter

-- ======= Base =======
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opts = { noremap = false , silent = true }  -- options
local term_opts = { silent = true } -- does not print the action
local keymap = vim.api.nvim_set_keymap -- calling of the nvim function

-- DEFAULT Keymap <commented>
-- <C-w> + (v or s) split the view

-- TAB Navigation
keymap("n", "<TAB>", ":tabprev<cr>", opts)  -- Previous Tab
-- keymap("n", "<S-Tab>", ":tabnext<cr>", opts)
keymap("n", "<leader><tab>", ":tabclose<cr>", opts)

-- Buffer Navigation
keymap("n", "<C-Right>", ":wincmd l<cr>", opts)
keymap("n", "<C-Left>", ":wincmd h<cr>", opts)


-- Harpoon
keymap("n", "<leader>h", ":lua require(\"harpoon.ui\").toggle_quick_menu()<cr>", opts) -- Shows harpoon menu
keymap("n", "<leader>sh", ":lua require(\"harpoon.mark\").add_file()<cr>", opts) -- Save's file to harpoon
