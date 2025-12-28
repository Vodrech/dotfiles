-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

config.font = wezterm.font('FiraCode Nerd Font', {weight="Regular", stretch="Normal", style="Normal"})

return config
