-- Completion
return {
	"saghen/blink.cmp",
	dependencies = {"rafamadriz/friendly-snippets"},
	config = function()
		require("blink.cmp").setup({
			keymap = {
				preset = "default"
			},
			completion = {
				documentation = {
					auto_show = true
				}
			},
			sources = {
				default = {"lsp", "path", "snippets", "buffer"}
			},
			fuzzy = {
				implementation = "prefer_rust_with_warning"
			},
			-- opts_extend = {"sources.default"}
		})
	end
}
