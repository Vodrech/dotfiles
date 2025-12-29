return {
				"stevearc/oil.nvim",
				opts = {},
				dependencies = {{"nvim-mini/mini.icons"}},
				lazy = false,
				config = function()
          require("oil").setup({})
					vim.keymap.set("n", "<leader>t", "<cmd>Oil<cr>", {desc = "Opens current folder"})
				end
}
