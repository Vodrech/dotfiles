-- Vodrech experimental functions
-- Needs to have a variable that has the session path

local auto_sessions = require("auto-session")
auto_sessions.setup({
	auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/"},
	log_level = "error",
	session_lens = {
    		-- If load_on_setup is set to false, one needs to eventually call `require("auto-session").setup_session_lens()` if they want to use session-lens.
    		load_on_setup = true,
    		theme_conf = { border = true },
    		previewer = false,
  },
})
