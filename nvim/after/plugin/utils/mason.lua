-- Ensured installed LSP's
local servers = {
	rust_analyzer = {},
	tsserver = {},
	pyrigth = {},
}

-- Mason Setup
require("mason").setup({
	ensure_installed = vim.tbl_keys(servers),
	ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})
