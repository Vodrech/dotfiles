local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- 1. Load the Matugen colors safely
local success, matugen_colors = pcall(dofile, "/home/vodrech/.cache/matugen/wezterm/colors.lua")

if success and matugen_colors then
    -- Optional: Tint the terminal background with your primary color 
    if matugen_colors.primary then
        matugen_colors.background = matugen_colors.primary
        matugen_colors.foreground = "#000000" -- ensure text stays readable if background is bright
    end

    config.color_schemes = {
        ["matugen_dynamic"] = matugen_colors,
    }
    config.color_scheme = "matugen_dynamic"

    -- 2. Style the Window Frame / Title Bar using Matugen colors
    config.window_frame = {
        active_titlebar_bg = matugen_colors.surface_variant or "#2b2042",
        inactive_titlebar_bg = matugen_colors.background or "#1a1110",
        active_titlebar_fg = matugen_colors.foreground or "#ffffff",
        inactive_titlebar_fg = matugen_colors.ansi and matugen_colors.ansi[1] or "#cccccc",
        -- Border color around the frame edges
        border_left_color = matugen_colors.primary,
        border_right_color = matugen_colors.primary,
        border_bottom_color = matugen_colors.primary,
        border_top_color = matugen_colors.primary,
    }
end

-- 3. Glassmorphism Settings (Transparency & Blur)
config.window_background_opacity = 0.85
config.wayland_window_background_blur = true

-- Optional window padding
config.window_padding = {
    left = '15pt',
    right = '15pt',
    top = '15pt',
    bottom = '15pt',
}

return config
