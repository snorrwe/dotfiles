return function()
    local fzf = require("fzf-lua")
    fzf.setup({
        keymap = {
            fzf = {
                ["ctrl-q"] = "select-all+accept",
            },
        },
    })

    vim.keymap.set("n", "<space>F", fzf.git_files)
    vim.keymap.set("n", "<space>f", fzf.files)
    vim.keymap.set("n", "<space>g", fzf.live_grep)
    vim.keymap.set("n", "<space>G", fzf.grep_curbuf)
    vim.keymap.set("n", "<space>b", fzf.buffers)
    vim.keymap.set("n", "<space>t", fzf.helptags)
    vim.keymap.set("n", "<space>l", fzf.lsp_workspace_diagnostics)
    vim.keymap.set("n", "<space><space>", fzf.resume)
    fzf.register_ui_select()
end
