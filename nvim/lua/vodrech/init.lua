-- User configurations for Vodrech
local create_group = vim.api.nvim_create_augroup -- Creates a augroup | :h augroup
create_group("user-config", { clear = true })

-- Required
require("vodrech.options") -- Default options
require("vodrech.remap") -- Default remaps/keymaps

-- Optional
require("vodrech.packer") -- Plugins @IMPORTANT
