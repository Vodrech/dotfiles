-- Vodrech Neovim configurations
--                                              @##@**((
--                                             #%********
--              .***/@&#@                     &#/********@
--             /********@#                     #@***@****%
--             @*********@#       ,(@@@@@&##########****@
--             &******&@**#%#########################@
--             /*********@##@#######@%##########@#####.
--               @******@####@#####@##@@%####@#@#######&
--                     /######@######&  @@@##(@ @#######@
--                    ,########@#######@(@#######@%######@
--                    ####@#####@##@#####/**@@@*%#&@######%
--                   ############%#####@@***@*,&*@#####&####
--                  #########&######%####@***,**%############(
--                 ######@###@################################@
--                ###@##%###%@@&###############################@  @##@#@
--               #####@@##@#########%###########################@##@##&
--              %####################&&@@#######################&####@
--             @######################@##################@@#
--                       .&@&######&#%###@###%@@*
--                                  @%###@
--                              Jerry the Cheese
--                               User: Vodrech

-- Map leaders | must be intilized before plugin manager
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- AU Group | for user autocommands | :h autocmd
vim.api.nvim_create_augroup("vodrech", { clear = true })

-- Check which Operation System | Windows or Linux
if package.config:sub(1, 1) == "\\" then
	vim.g.system = "Windows"
else
	vim.g.system = "Linux"
end

-- Default & Important imports
pcall(require("prerequisites"))
pcall(require("default.option"))
pcall(require("default.remap"))

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

-- Add lazy to the `runtimepath`, this allows us to `require` it.
---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- Set up lazy, and load my `lua/custom/plugins/` folder
require("lazy").setup({ import = "plugins" }, {
	change_detection = {
		notify = false,
	},
})
