-- Plugin loader [Lazy.nvim]
-- Utils --> Important configurations for the general nvim experience
-- Modules --> Essential functionality [very nice to have :')]
-- Extensions --> Nice to have, but does not impact working experience
-- Experimental --> Testing | enventually removed/moved to another section
-- Local --> Self created plugins

-- Experimental
local experimental = {
	{'github/copilot.vim', priority=100}
}

-- Local
local local_plugins = {
	{dir = tostring(os.getenv("NVIM_LOCAL_PLUGIN")) .. "skalbagge.nvim", priority = 200},
}

-- Utils
local utils = {
	{'nvim-treesitter/nvim-treesitter', priority = 1}, -- Text highlighter
	{'nvim-lua/plenary.nvim', priority = 2}, -- Collection of lua functions
	{'nvim-telescope/telescope.nvim', priority = 3, dependencies = {'nvim-lua/plenary.nvim'}}, -- File navigator
	{'rcarriga/nvim-notify', priority = 4}, -- Notifications
	{'nvim-lualine/lualine.nvim', priority = 1000}, -- Status Line
}

-- Modules
local modules = {
	git = {{'tpope/vim-rhubarb', dependencies = {'tpope/vim-fugitive'}}},
	lsp = {{'neovim/nvim-lspconfig', dependencies = { -- Main LSP integration
		'williamboman/mason.nvim', -- LSP Manager/Installer
		'williamboman/mason-lspconfig.nvim', -- Mason LSP integration helper to lspconfig
		{'j-hui/fidget.nvim', opts = {}}, -- UI/Progressbar for LSP
		{'folke/neodev.nvim', dependencies = {'hrsh7th/nvim-cmp'}}, -- Neovim config helper
	}}},
	completion = {
		{'hrsh7th/nvim-cmp',  dependencies = {'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip'}},
		{'folke/which-key.nvim'}, -- Show possible key bindings of command
		{'lewis6991/gitsigns.nvim'}, -- NEEDED?
	}
}

-- Extensions
local extensions = {
	{'lukas-reineke/indent-blankline.nvim'}, -- Indentation highlighter
	{'numToStr/Comment.nvim'}, -- Comment/UnComment code
	-- {'nvim-tree/nvim-tree.lua'},
	{'ThePrimeagen/harpoon'},
	{'folke/tokyonight.nvim', priority = 999},
}

-- Adding the tables to Plugin manager
plugins = {
	utils,
	modules.git,
	modules.lsp,
	modules.completion,
	extensions,
	experimental,
	local_plugins
}
require("lazy").setup(plugins, {})
