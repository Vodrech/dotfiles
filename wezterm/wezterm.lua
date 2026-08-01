local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- 1. Load the Matugen colors directly using dofile (bypasses package.path search errors)
local success, matugen_colors = pcall(dofile, "/home/vodrech/.cache/matugen/wezterm/colors.lua")

if success and matugen_colors then
    -- 2. Register and apply the dynamic color scheme
    config.color_schemes = {
        ["matugen_dynamic"] = matugen_colors,
    }
    config.color_scheme = "matugen_dynamic"
end

-- 3. Glassmorphism Settings (Transparency & Blur)
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
