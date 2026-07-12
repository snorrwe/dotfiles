local formatOnSave = true
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function(args)
        if formatOnSave then
            require("conform").format({ bufnr = args.buf, async = false, lsp_fallback = "always" })
        end
    end,
})

vim.api.nvim_create_user_command("ToggleFormatOnSave", function()
    formatOnSave = not formatOnSave
    if formatOnSave then
        print("formatOnSave enabled")
    else
        print("formatOnSave disabled")
    end
end, {})

vim.keymap.set("n", "<leader>tf", "<cmd>ToggleFormatOnSave<CR>")
