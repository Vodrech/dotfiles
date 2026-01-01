-- AI IDE
return {
  "yetone/avante.nvim",
	dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
	},
  build = vim.fn.has("win32") ~= 0
      and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
      or "make",
  event = "VeryLazy",
  version = false, -- Never set this value to "*"! Never!
  opts = {
    instructions_file = "avante.md",
    endpoint = "http://localhost:11434",  -- Ollama local HTTP endpoint
  },
	config = function()
		require("avante").setup({
			override_system_prompt = {message = "what is 9 + 10?"},
			provider = "ollama",
			providers = {
				ollama = {
				endpoint = "http://localhost:11434",
				model = "deepseek-r1:1.5b",
				hide_in_model_selector = false,
				legacy = true,
				disable_tools = true,
				extra_request_body = {
					message = "this message",
				}
			}
			}
			})
	end
}
