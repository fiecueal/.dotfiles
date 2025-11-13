local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local act = wezterm.action

config.keys = {
  { key = 'UpArrow',   mods = 'SHIFT', action = act.ScrollByLine(-2) },
  { key = 'DownArrow', mods = 'SHIFT', action = act.ScrollByLine(2) },
}

config.mouse_bindings = { {
  event = { Up = { streak = 1, button = 'Left' } },
  mods = 'NONE',
  action = act.CompleteSelection 'PrimarySelection'
}, {
  event = { Up = { streak = 2, button = 'Left' } },
  mods = 'NONE',
  action = act.OpenLinkAtMouseCursor
} }

config.default_cursor_style = "SteadyBlock"
config.enable_scroll_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false

config.font_size = 11
config.font = wezterm.font_with_fallback {
  'OCRA',
  'Noto Sans CJK JP',
}

config.color_scheme = 'hardhacker'
local colors = wezterm.color.get_default_colors()
config.colors = {
  cursor_bg = colors.foreground,
  cursor_fg = colors.background
}

return config
