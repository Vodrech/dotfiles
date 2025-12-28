-- Vodrech Neovim config 2025/2026

vim.g.mapleader = " "

-- # Base Config | Put stuff here incase the config crashes and stuff just works :)

-- -- # Movement
vim.api.nvim_set_keymap("n", "<C-Right>", ":wincmd l<cr>", {noremap = false, silent = true})
vim.api.nvim_set_keymap("n", "<C-Left>", ":wincmd h<cr>", {noremap = false, silent = true})
vim.api.nvim_set_keymap("n", "<C-Up>", ":wincmd k<cr>", {noremap = false, silent = true})
vim.api.nvim_set_keymap("n", "<C-Down>", ":wincmd j<cr>", {noremap = false, silent = true})
vim.api.nvim_set_keymap("n", "<leader>ff", ":Explore<cr>", {noremap = false, silent = true})

-- -- # Options
vim.o.number = true
vim.o.relativenumber = true
vim.o.autoindent = true
vim.o.softtabstop = 2
vim.o.tabstop=2
vim.o.cursorline = true
vim.o.scrolloff = 8

-- Imports
-- pscall(require("options"))
