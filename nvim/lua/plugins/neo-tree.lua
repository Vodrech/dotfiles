return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    lazy = false, -- neo-tree will lazily load itself
		config = function()
			require("neo-tree").setup({
  close_if_last_window = false, -- keep the tree open even if it's the last window
  popup_border_style = "rounded",
  enable_git_status = true,
  enable_diagnostics = true,
  default_component_configs = {
    indent = {
      padding = 1,
    },
  },
  window = {
    position = "left",   -- always open on the left
    width = 30,          -- set the width of the sidebar
    mapping_options = {
      noremap = true,
      nowait = true,
    },
  },
  filesystem = {
    filtered_items = {
      visible = true,  -- show hidden files if you want
    },
    follow_current_file = true, -- highlight the current file in the tree
    hijack_netrw_behavior = "open_default",
  },
})

		end,
		vim.keymap.set("n", "<leader>te", "<Cmd>Neotree toggle<CR>"),
		vim.keymap.set("n", "<leader>tf", "<Cmd>Neotree focus<CR>"),
  }
}
