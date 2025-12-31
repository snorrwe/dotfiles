local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme = "Catppuccin Mocha"

config.font = wezterm.font("MonaspiceNe Nerd Font")
config.font_size = 13

config.enable_wayland = false
config.warn_about_missing_glyphs = false

config.check_for_updates = false

config.enable_tab_bar = false

return config
