local wezterm = require 'wezterm'
local config = wezterm.config_builder()

local success, matugen_colors = pcall(dofile, "/home/vodrech/.cache/matugen/wezterm/colors.lua")

if success and matugen_colors then
    -- Force the background to take your vibrant primary color 
    -- (or use matugen_colors.primary_container for a softer, tinted look)
    if matugen_colors.primary then
        matugen_colors.background = matugen_colors.primary
        -- Make text dark if your primary color is bright, so you can still read it:
        matugen_colors.foreground = "#000000" 
    end

    config.color_schemes = {
        ["matugen_dynamic"] = matugen_colors,
    }
    config.color_scheme = "matugen_dynamic"
end

-- Glassmorphism settings
config.window_background_opacity = 0.85
config.wayland_window_background_blur = true

return config
