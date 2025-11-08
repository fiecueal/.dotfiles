local wezterm = require 'wezterm'
local config  = wezterm.config_builder()
local act = wezterm.action

config.keys = {
  { key = 'UpArrow',   mods = 'SHIFT', action = act.ScrollByLine(-1) },
  { key = 'DownArrow', mods = 'SHIFT', action = act.ScrollByLine(1) },
}

config.enable_scroll_bar = true
config.hide_tab_bar_if_only_one_tab = true

--TODO custom colors
config.color_scheme = 'hardhacker'
config.font = wezterm.font_with_fallback {
  'OCR A',
  'Noto Mono',
}
config.font_size = 12

config.background = {{
  source = {File = wezterm.config_dir..'/99448728_p0.jpg'},
  vertical_align   = 'Middle',
  horizontal_align = 'Center',
  opacity = 0.3
}}

return config
