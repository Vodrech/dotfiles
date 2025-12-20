-- Pre-requisites for nvim configuration

vim.g.essential_variables = false
vim.g.essential_tools = false

-- Essential Tools
local essential_tools = {
	"rg", -- Ripgrep
	"fd", -- File Directory
	"curl",
}

local essential_variables = {
	"CONFIG_FOLDER", -- Necessary for scripts
	"DEV_ENV", -- Development Environment | lualine uses this
}

function windows()
	-- Check For Essential Tools
	local non_installed_tools = "Non Installed Essential Tools \n"
	local has_tools_error = false
	for i, x in pairs(essential_tools) do
		local handle = io.popen(string.format("where.exe %s", x))
		local result = handle:read("*all")
		handle:close()
		if result == "" then
			has_error = true
			non_installed_tools = non_installed_tools .. "|" .. x .. "|" .. "\n"
		end
	end

	-- Sets essential_tools global and print if error
	if has_tools_error then
		vim.notify(non_installed_tools, "error")
	else
		vim.g.essential_tools = true
	end

	-- Check for Essential Variables
	local non_installed_variables = "Non Installed Essential Variables \n"
	has_variables_error = false
	for i, x in pairs(essential_variables) do
		local env = os.getenv(x)
		if env == nil then
			has_variables_error = true
			non_installed_variables = non_installed_variables .. "|" .. x .. "|" .. "\n"
		end
	end

	-- Sets essential_variables global and print if error
	if has_variables_error then
		vim.notify(non_installed_variables, "error")
	else
		vim.g.essential_variables = true
	end
end

-- Windows Setup
if vim.g.system == "Windows" then
	-- Autocmd to run on nvim startup
	vim.api.nvim_create_autocmd({ "VimEnter" }, {
		pattern = { "*" },
		callback = function()
			windows()
		end,
	})
elseif vim.g.system == "Linux" then
	print("Linux Setup needs to be configured")
end
