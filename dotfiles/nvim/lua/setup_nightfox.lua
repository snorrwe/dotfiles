local colors = require("colors")

local M = {}

local options = {
    transparent = false,
    dim_inactive = true,
    colorblind = {
        enable = true,
        severity = {
            protan = 0.72,
        },
    },
}
M.options = options

M.config = function()
    require("nightfox").setup({ options = options })
    vim.cmd("colorscheme " .. colors.dark)
end

M.build = function()
    require("nightfox").setup({ options = options })
    require("nightfox").compile()
end

return M
