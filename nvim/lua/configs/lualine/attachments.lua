-- Attachments for lualine
-- Loading = configs.lualine.attachments

return {
	icons = {
		mode = {
			n = "#c4746e",
			no = "#c4746e",
			cv = "#c4746e",
			ce = "#c4746e",
			["!"] = "#c4746e",
			t = "#c4746e",
			i = "#87a987",
			v = "#658594",
			V = "#658594",
			c = "#8ea4a2",
			s = "#b6927b",
			S = "#b6927b",
			ic = "#c4b28a",
			R = "#8992a7",
			Rv = "#949fb5",
			r = "#949fb5",
			rm = "#949fb5",
		},
		component = {
			left_seperator = "",
			right_seperator = "",
		},
		section = {

			left_seperator = "",
			right_seperator = "",
		},
		general = {
			mode = "",
			git_branch = "",
			error = " ",
			warn = " ",
			info = " ",
			hint = " ",
			added = " ",
			modified = "󰝤 ",
			modified_simple = "~ ",
			removed = " ",
			lock = "",
			touched = "●",
		},
	},
	colors = {
		lsp = {
			lua_ls = {
				fg = "#6600ff", -- Purple
			},
			rust_analyzer = {
				fg = "#ff6600", -- Orange
			},
			tsserver = {
				fg = "#0066ff", -- Blue
			},
		},
	},
}
