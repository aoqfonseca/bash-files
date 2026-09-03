local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.adjust_window_size_when_changing_font_size = false
config.enable_tab_bar = true
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

-- Set Zsh as the default program and run it as a login shell
config.default_prog = { "/bin/zsh", "-l" }

-- Generic configs
config.front_end = "WebGpu"

-- Color
config.color_scheme = "Catppuccin Mocha"
config.window_background_opacity = 0.9

--Font config
--config.font = wezterm.font("IosevkaTerm Nerd Font")
config.font = wezterm.font("Inconsolata Nerd Font", { weight = "DemiBold" })
config.font_size = 16
config.window_decorations = "RESIZE"

--Config Keys
config.keys = {
	{
		key = "k",
		mods = "CMD|SHIFT",
		action = wezterm.action.ScrollToPrompt(-1),
	},
	{
		key = "j",
		mods = "CMD|SHIFT",
		action = wezterm.action.ScrollToPrompt(1),
	},

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

wezterm.on("update-status", function(window, pane)
	-- Get the effective configuration
	local config = window:effective_config()

	-- Extract font details
	local font_family = config.font.font[1].family
	local font_size = config.font_size

	-- Format the status string
	local font_status = string.format(": %s, size [%s]   ", font_family, font_size)

	-- Set the right status
	window:set_right_status(wezterm.format({
		{ Background = { Color = "black" } },
		{ Foreground = { Color = "white" } },
		{ Text = wezterm.nerdfonts.md_format_font .. " " .. font_status },
	}))
end)

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	-- Only apply the tmux session label to the currently focused tab
	if tab.is_active then
		local tmux_session = tab.active_pane.user_vars.tmux_session
		if tmux_session and #tmux_session > 0 then
			return " 📦 " .. tmux_session .. " "
		end
	end

	return " " .. tab.active_pane.title .. " "
end)

local tmux_session = require("plugins/tmux-session")
tmux_session.apply_to_config(config)

local font_selector = require("plugins/font-selector")
font_selector.apply_to_config(config)

return config
