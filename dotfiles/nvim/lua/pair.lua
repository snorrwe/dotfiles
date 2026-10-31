local colors = require("colors")
local pairMode = false

vim.api.nvim_create_user_command("TogglePair", function()
    pairMode = not pairMode
    if pairMode then
        vim.cmd("colorscheme " .. colors.light)
        vim.opt.relativenumber = false
    else
        vim.cmd("colorscheme " .. colors.dark)
        vim.opt.relativenumber = true
    end
end, {})
vim.keymap.set("n", "<leader>tp", "<cmd>TogglePair<CR>")
