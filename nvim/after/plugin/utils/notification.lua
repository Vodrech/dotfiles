--  , _ ,
-- ( o o )  Hedwig and his functionality is awesome when it comes to
--/'` ' `'\   delivering messages.
--|'''''''|   AKA: Notifications/Messages
--|\\'''//|
--   """
-- :lua require("notify")("<message>") || :lua vim.notify("message")
-- :Telescope notify || :Notifications

local notify = require('notify')
vim.notify = notify -- Overrides the default functionality

notify.setup({
	icons = {
          DEBUG = "",
          ERROR = "",
          INFO = "",
          TRACE = "✎",
          WARN = "",
	},
	stages = "slide",
	render = "compact",
	fps = 60,
})

-- vim.notify("This is an error message.\nSomething went wrong!", "error", {
--   title = plugin,
--   on_open = function()
--     vim.notify("Attempting recovery.", vim.log.levels.WARN, {
--       title = plugin,
--     })
--     local timer = vim.loop.new_timer()
--     timer:start(2000, 0, function()
--       vim.notify({ "Fixing problem.", "Please wait..." }, "info", {
--         title = plugin,
--         timeout = 3000,
--         on_close = function()
--           vim.notify("Problem solved", nil, { title = plugin })
--           vim.notify("Error code 0x0395AF", 1, { title = plugin })
--         end,
--       })
--     end)
--   end,
-- })
-- Default configurtions
