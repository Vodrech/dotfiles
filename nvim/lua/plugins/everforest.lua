-- COLORTHEME
return {
  "neanias/everforest-nvim",
	priority = 1000,
	config = function()
					require("everforest").setup({
							background = "medium"
					})

					-- Sets the colortheme
					local ok, _ = pcall(vim.cmd, "colorscheme everforest")
					if not ok then
						vim.notify("Colorscheme not found!", vim.log.levels.WARN)
					end
	end
}
