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
vim.api.nvim_create_augroup("vodrech", {clear = true})

-- Plugin Manager | installs if not exists
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Important
require("vodrech.option") -- Options
require("vodrech.remap") -- Keymappings
require("vodrech.plugin") -- Plugins
require("vodrech.experimental") -- Experimental
