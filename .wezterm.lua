local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.color_scheme = 'catppuccin-mocha'

config.font = wezterm.font('Monaspace Neon')
config.font_size = 15

return config
