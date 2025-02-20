local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- Color
config.color_scheme = "Dracula+"
config.window_background_opacity = 0.8

--Font config
config.font = wezterm.font("0xProto Nerd Font")
config.font_dirs = { ".fonts" }
config.font_size = 11

return config
