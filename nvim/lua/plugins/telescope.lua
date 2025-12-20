-- Telescope Plugin
return {
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.6',
		priority = 200,
		dependencies = { 
			'nvim-lua/plenary.nvim' 
		},
		config = function()
			require('configs.telescope')
		end
	}
}
