local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme = "Catppuccin Mocha"

config.font = wezterm.font("Monaspace Neon")
config.font_size = 13

config.enable_wayland = false
config.warn_about_missing_glyphs = false

config.check_for_updates = false

config.enable_tab_bar = false
config.keys = {
	{ key = "O", mods = "SHIFT|CTRL", action = wezterm.action.ShowTabNavigator },
}

return config
