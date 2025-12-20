local options = {
	mouse = "a",
	cursorline = true,
	termguicolors = true,
	guifont = "monospace:h17", -- Emojis
	number = true, -- Linenumbers
	scrolloff = 999, -- Keeps cursor in the middle
	list = true, -- Enables listchars
	shiftwidth = 2, -- Number of spaces to use for autoindent
	tabstop = 2, -- Number of spaces that a <Tab> in the file counts for
	relativenumber = true, -- Linenumbers gets relative to current pos
	colorcolumn = "80",
	showtabline = 2, -- Always show tabline
	showmode = false, -- Lualine shows this anyway
}

vim.cmd("set listchars=tab:┆\\ →,leadmultispace:†\\ ·\\ ‡\\ ·\\ ,trail:◣,precedes:←,extends:※")
for k, v in pairs(options) do
	vim.opt[k] = v
end
