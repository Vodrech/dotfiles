--       ,~~.
--      (  9 )-_,
-- (\___ )=='-'
--  \ .   ) )       Plugins Management file
--   \ `-' /
--    `~j-'
--      "=:

-- Only required if you have packer configured as `opt`
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
  vim.cmd [[packadd packer.nvim]]
end

-- Packer main function
return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- Fuzzy finder & File manager | ~/../after/plugin/telescope.lua
  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.0',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- Colorscheme & Background | ~/../after/plugin/colors.lua
  use {
	  'rose-pine/neovim',
	  as = 'rose-pine',
	  config = function()
		  vim.cmd('colorscheme rose-pine')
	  end
  }

  use {
	  'ThePrimeagen/harpoon',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }

  use {
	
  } 

  -- Colorcheme on Code
  use {
	  'nvim-treesitter/nvim-treesitter',
	  run = ':TSUpdate'
  }

  -- Statusline | ~/../after/statusline.lua
  use {
	  'nvim-lualine/lualine.nvim',
	  requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  -- LSP Base Support | ~/../after/lsp.lua
  use {
  'VonHeikemen/lsp-zero.nvim',
  requires = {
    -- LSP Support
    {'neovim/nvim-lspconfig'},
    {'williamboman/mason.nvim'}, -- Helps alot with LSP installs
    {'williamboman/mason-lspconfig.nvim'},

    -- Autocompletion
    {'hrsh7th/nvim-cmp'},
    {'hrsh7th/cmp-buffer'},
    {'hrsh7th/cmp-path'},
    {'saadparwaiz1/cmp_luasnip'},
    {'hrsh7th/cmp-nvim-lsp'},
    {'hrsh7th/cmp-nvim-lua'},

    -- Snippets
    {'L3MON4D3/LuaSnip'},
    {'rafamadriz/friendly-snippets'},
  }
}

  -- Automatically set up your configuration after cloning packer.nvim
  -- -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
