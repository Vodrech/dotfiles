local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- 1. Load the Matugen colors safely
local success, matugen_colors = pcall(dofile, "/home/vodrech/.cache/matugen/wezterm/colors.lua")

if success and matugen_colors then
    -- 2. Customize the background to use your primary color 
    -- (matugen_colors.cursor_bg or matugen_colors.ansi[2] usually holds your primary color)
    if matugen_colors.cursor_bg then
        matugen_colors.background = matugen_colors.cursor_bg
    end

    -- 3. Register and apply the dynamic color scheme
    config.color_schemes = {
        ["matugen_dynamic"] = matugen_colors,
    }
    config.color_scheme = "matugen_dynamic"
end

-- 4. Glassmorphism Settings (Transparency & Blur)
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
