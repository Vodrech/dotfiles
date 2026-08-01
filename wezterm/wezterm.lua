local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- 1. Point to your WezTerm Matugen cache directory
package.path = package.path .. ";/home/vodrech/.cache/matugen/wezterm/?.lua"

-- 2. Load the dynamic colors
local matugen_colors = require("colors")
config.colors = matugen_colors

-- 3. Glassmorphism Settings
config.window_background_opacity = 0.85
config.wayland_window_background_blur = true

-- Optional window styling padding
config.window_padding = {
    left = '15pt',
    right = '15pt',
    top = '15pt',
    bottom = '15pt',
}

return config
