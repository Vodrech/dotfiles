local wezterm = require("wezterm")
local act = wezterm.action

-- 1. Load the Matugen colors safely
local success, matugen_colors = pcall(dofile, "/home/vodrech/.cache/matugen/wezterm/colors.lua")

-- 2. Define scheme_def strictly based on Matugen if available
local scheme_def
if success and matugen_colors then
    scheme_def = matugen_colors
else
    scheme_def = wezterm.color.get_builtin_schemes()['duckbones']
end

-- Fallback primary color definition
local primary_color = scheme_def.primary or scheme_def.background or "#2b2042"

local function brightness_auto_adjust(hex, amount)
  if not hex or #hex ~= 7 or hex:sub(1, 1) ~= "#" then
    return primary_color
  end
  
  amount = math.min(math.max(amount, 0), 1)
  local r = tonumber(hex:sub(2, 3), 16)
  local g = tonumber(hex:sub(4, 5), 16)
  local b = tonumber(hex:sub(6, 7), 16)
  
  local brightness = (0.2126 * r + 0.7152 * g + 0.0722 * b) / 255
  
  if brightness < 0.5 then
    r = math.min(255, math.floor(r + (255 - r) * amount))
    g = math.min(255, math.floor(g + (255 - g) * amount))
    b = math.min(255, math.floor(b + (255 - b) * amount))
  else
    r = math.max(0, math.floor(r * (1 - amount)))
    g = math.max(0, math.floor(g * (1 - amount)))
    b = math.max(0, math.floor(b * (1 - amount)))
  end
  
  return string.format("#%02X%02X%02X", r, g, b)
end

local function getDirectoryName(path)
  if not path then
    return 'Unknown'
  end
  path = path:gsub("/+$", "")
  local directoryName = path:match("([^/]+)$")
  return directoryName or 'Unknown'
end

local process_icons = {
  ['docker'] = wezterm.nerdfonts.linux_docker,
  ['docker-compose'] = wezterm.nerdfonts.linux_docker,
  ['psql'] = wezterm.nerdfonts.dev_postgresql,
  ['nvim'] = wezterm.nerdfonts.custom_vim,
  ['make'] = wezterm.nerdfonts.seti_makefile,
  ['vim'] = wezterm.nerdfonts.dev_vim,
  ['go'] = wezterm.nerdfonts.seti_go,
  ['zsh'] = wezterm.nerdfonts.dev_terminal,
  ['bash'] = wezterm.nerdfonts.cod_terminal_bash,
  ['btm'] = wezterm.nerdfonts.mdi_chart_donut_variant,
  ['cargo'] = wezterm.nerdfonts.dev_rust,
  ['git'] = wezterm.nerdfonts.dev_git,
  ['lua'] = wezterm.nerdfonts.seti_lua,
  ['node'] = wezterm.nerdfonts.dev_nodejs_small,
}

local function get_process(tab)
  local process_name = tab.active_pane.foreground_process_name
  if not process_name then return wezterm.nerdfonts.seti_checkbox_unchecked end
  
  local clean_name = process_name:match("([^/\\]+)%.exe$") or process_name:match("([^/\\]+)$")
  return process_icons[clean_name] or wezterm.nerdfonts.seti_checkbox_unchecked
end

local config = wezterm.config_builder()

config.max_fps = 120

-- FONTS:
config.font = wezterm.font_with_fallback {
  'JetBrainsMono Nerd Font Mono',
  'MesloLGS Nerd Font Mono', 
  'Noto Color Emoji',
}
config.font_size = 15

-- COLORS CONFIGURATION:
if success and matugen_colors then
    config.color_schemes = {
        ["matugen_dynamic"] = matugen_colors,
    }
    config.color_scheme = "matugen_dynamic"
else
    config.color_scheme = 'duckbones'
end

-- Calculating colors dynamically based on Matugen source scheme:
local base_color = primary_color
local color_bg_100 = brightness_auto_adjust(base_color, 0.100)
local color_bg_165 = brightness_auto_adjust(base_color, 0.165)
local color_bg_300 = brightness_auto_adjust(base_color, 0.300)
local color_bg_500 = brightness_auto_adjust(base_color, 0.500)
local color_hl = scheme_def.cursor_bg or scheme_def.foreground or "#ffffff"

-- Sizings and Spacings:
config.window_padding = {
  left = 24,
  right = 24,
  top = 24,
  bottom = 12
}

config.initial_cols = 93
config.initial_rows = 45

-- TABBAR: Force Top Bar to use Matugen Primary Color
config.window_decorations = "INTEGRATED_BUTTONS | RESIZE"
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = false

config.window_frame = {
    font = wezterm.font { family = 'Roboto', weight = 'DemiBold' },
    font_size = 14,
    
    active_titlebar_bg   = primary_color,
    inactive_titlebar_bg = primary_color,
    
    active_titlebar_fg   = scheme_def.foreground or "#ffffff",
    inactive_titlebar_fg = scheme_def.foreground or "#cccccc",

    border_bottom_height = '1px',
    border_left_width = '1px',
    border_right_width = '1px',
    
    border_bottom_color = color_bg_300,
    border_left_color = color_bg_300,
    border_right_color = color_bg_300,
}

config.colors = {
    tab_bar = {
        background = primary_color,
        inactive_tab_edge = color_bg_500,

        active_tab = {
            bg_color = scheme_def.background or primary_color,
            fg_color = scheme_def.foreground or "#ffffff",
        },

        inactive_tab = {
            bg_color = 'none',
            fg_color = color_bg_500,
        },
    }
}

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local pane = tab.active_pane
  local cwd_uri = pane.current_working_dir
  local directoryName = 'Unknown'
  local process = get_process(tab)

  if cwd_uri then
    local cwd_path = cwd_uri.file_path
    directoryName = getDirectoryName(cwd_path)
  end

  local title = string.format(' ⌘%s  %s  %s', (tab.tab_index + 1), directoryName, process) 

  return {
    { Text = title },
  }
end)

-- STATUS BAR:
wezterm.on('update-right-status', function(window, pane)
  local workspace = window:active_workspace()
  local cwd_uri = pane:get_current_working_dir()
  local directoryName = cwd_uri and getDirectoryName(cwd_uri.file_path) or 'Unknown'

  window:set_right_status(wezterm.format({
    { Foreground = { Color = scheme_def.foreground or "#ffffff" } },
    { Background = { Color = 'none' } },
    { Text = wezterm.nerdfonts.oct_table .. " " .. workspace },
    { Text = " | " },
    { Text = wezterm.nerdfonts.md_folder .. " " .. directoryName },
    { Text = "    " },
  }))
end)

-- KEY BINDINGS:
config.keys = {
  {
    key = 'LeftArrow',
    mods = 'OPT|CMD',
    action = act.ActivateTabRelative(-1),
  },
  {
    key = 'RightArrow',
    mods = 'OPT|CMD',
    action = act.ActivateTabRelative(1),
  },
}

return config
