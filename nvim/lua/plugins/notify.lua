
return {
	{
		'rcarriga/nvim-notify',
		lazy = false,
		priority = 1,
		config = function()
			vim.notify = require("notify")
		end,
	}
}
