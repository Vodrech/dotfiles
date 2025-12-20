return {
  {
    "hrsh7th/nvim-cmp",
    lazy = false,
    priority = 100,
    dependencies = {
	    {
		    "onsails/lspkind.nvim",
		    config = function ()
			    require "configs.completion.lspkind"
		    end,
	    },
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      { "L3MON4D3/LuaSnip", build = "make install_jsregexp" },
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      require "configs.completion"
    end,
  },
}
