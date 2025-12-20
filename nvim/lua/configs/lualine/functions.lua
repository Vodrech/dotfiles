-- Lualine Functions
-- Loading = configs.lualine.functions
local attachments = require("configs.lualine.attachments")
local has_secret, secrets = pcall(require, "configs.lualine.secret")

local lsp_icons = {
	lua_ls = "",
	tsserver = "󰛦",
	rust_analyzer = "",
}

local condition = {
	is_buf_empty = function()
		return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
	end,
	is_git_repo = function()
		local filepath = vim.fn.expand("%:p:h")
		local gitdir = vim.fn.finddir(".git", filepath .. ";")
		return gitdir and #gitdir > 0 and #gitdir < #filepath
	end,
}

local function get_char_after(input_str, target_char)
	local start_pos = string.find(input_str, target_char)
	if start_pos and start_pos < #input_str then
		return string.sub(input_str, start_pos + 1, start_pos + 1)
	else
		return nil
	end
end

return {

	-- MODE COMPONENT
	mode_component = {
		function()
			return attachments.icons.general.mode
		end,
		color = function()
			return {
				fg = attachments.icons.mode[vim.fn.mode()],
			}
		end,
	},

	-- LSP COMPONENT
	lsp_client_component = {
		function()
			local clients = vim.lsp.get_clients()
			local list = {}
			for _, client in pairs(clients) do
				table.insert(list, lsp_icons[client.name])
				if list == nil then
					return "~"
				end
				return table.concat(list, "|")
			end
		end,
		color = {
			fg = "#000000",
			bg = "#ffffff",
		},
	},

	changed_component = {
		"filename",
		cond = condition.is_buf_empty,
		path = 0,
		symbols = {
			modified = attachments.icons.general.touched,
			readonly = attachments.icons.general.lock,
			unnamed = "[No Name]",
			newfile = "[New]",
		},
	},

	develop_environment_component = {
		function()
			-- Return NONE if the essential_variables not set
			if vim.g.essential_variables then
				return os.getenv("DEV_ENV")
			else
				return "NONE"
			end
		end,
		color = function()
			if vim.g.essential_variables then
				local dev_env = os.getenv("DEV_ENV")
				if has_secret then
					return secrets.environment[dev_env]
				else
					return {
						fg = "#ffffff",
						bg = "#000000",
					}
				end
			else
				return {
					fg = "#ffffff",
					bg = "#000000",
				}
			end
		end,
	},

	current_directory = {
		function()
			local curr_dir
			if vim.g.system == "Windows" then
				curr_dir = string.gsub(vim.fn.getcwd(), "^.*\\", "")
				return " " .. curr_dir
			elseif vim.g.system == "Linux" then
				return " " -- TODO: Needs a fix
			end
		end,
	},
}
