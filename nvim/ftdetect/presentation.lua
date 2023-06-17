-- ----------- Info  -----------
-- Handles pre initilization with autocmd 
-- This file is mainly for defining own file types
-- ----------- Help ------------
-- :help new-filetype
-- :echo &filetype
vim.cmd("au BufRead,BufNewFile *.vpm setlocal filetype=vim_presentation_mode")
