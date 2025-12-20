require "configs.completion.luasnip"
local lspkind = require('lspkind')

vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.shortmess:append "c"

local lspkind = require "lspkind"
lspkind.init {}

local cmp = require "cmp"

cmp.setup {
  sources = {
    { name = 'luasnip' },
    { name = "nvim_lsp" }, -- Completion for LSP
    { name = "path" }, -- Completion for Path
  },
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
  mapping = {
    ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
    ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
    ["<C-y>"] = cmp.mapping(
      cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      },
      { "i", "c" }
    ),
  },
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
}

