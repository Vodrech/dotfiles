-- Vodrech Neovim config 2025/2026

vim.g.mapleader = " "

-- # Base Config | Put stuff here incase the config crashes and stuff just works :)

-- -- # Movement
vim.keymap.set("n", "<C-Right>", ":wincmd l<cr>", {noremap = false, silent = true})
vim.keymap.set("n", "<C-Left>", ":wincmd h<cr>", {noremap = false, silent = true})
vim.keymap.set("n", "<C-Up>", ":wincmd k<cr>", {noremap = false, silent = true})
vim.keymap.set("n", "<C-Down>", ":wincmd j<cr>", {noremap = false, silent = true})
vim.keymap.set("n", "<leader>ff", ":Explore<cr>", {noremap = true, silent = true})

-- -- # Options
vim.o.number = true
vim.o.relativenumber = true
vim.o.autoindent = true
vim.o.softtabstop = 2
vim.o.tabstop=2
vim.o.shiftwidth = 2
vim.o.cursorline = true
vim.o.scrolloff = 8
vim.o.laststatus = 3

-- -- # LSP -- checkhealth vim.lsp
vim.lsp.enable({"lua_ls", "rust_analyzer", "ts_ls"})

-- IMPORTS
pcall(require("base")) -- Base configurations
require("config.lazy") -- Package Manager
pcall(require("config.lsp")) -- LSP CONFIG
