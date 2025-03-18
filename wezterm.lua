local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.adjust_window_size_when_changing_font_size = false
config.enable_tab_bar = false

-- Color
config.color_scheme = "Catppuccin Mocha"
config.window_background_opacity = 0.9

--Font config
config.font = wezterm.font("0xProto Nerd Font")
config.font_dirs = { ".fonts" }
config.font_size = 12
config.window_decorations = "RESIZE"
config.keys = {
	{
		key = "q",
		mods = "CTRL",
		action = wezterm.action.ToggleFullScreen,
	},
	{
		key = "Delete",
		mods = "CTRL",
		action = wezterm.action.ClearScrollback("ScrollbackAndViewport"),
	},
}
config.mouse_bindings = {
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
}

return config
