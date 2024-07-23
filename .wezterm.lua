local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.color_scheme = 'Catppuccin Mocha'

config.font = wezterm.font('Monaspace Neon')
config.font_size = 13

config.enable_wayland = false;

return config
