return function()
    local clangd_extensions = require("clangd_extensions")

    -- Set capabilities before vim.lsp.enable() calls
    vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
    })

    -- clangd: system install via clang-tools in home.packages
    vim.lsp.config.clangd = {
        filetypes = { "cpp", "c", "cuda" },
        cmd = { "clangd", "--background-index", "--log=verbose", "--clang-tidy" },
    }

    for _, server in ipairs(vim.g.lsp_servers or {}) do
        vim.lsp.enable(server)
    end

    clangd_extensions.setup({
        extensions = {
            autoSetHints = false,
        },
    })

    local group = vim.api.nvim_create_augroup("UserLspConfig", {})
    vim.api.nvim_create_autocmd("LspAttach", {
        pattern = { "*.c", "*.h", "*.hpp", "*.cpp", "*.cu", "*.cuh", "*.cc" },
        group = group,
        callback = function(ev)
            local opts = { buffer = ev.buf }
            vim.keymap.set("n", "gh", "<cmd>ClangdSwitchSourceHeader<cr>", opts)
        end,
    })
    vim.api.nvim_create_autocmd("LspAttach", {
        group = group,
        callback = function(ev)
            local fzf = require("fzf-lua")
            local opts = { buffer = ev.buf }
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
            vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
            vim.keymap.set({ "n", "v" }, "ga", fzf.lsp_code_actions, opts)
            vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
            vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
            vim.keymap.set("n", "<space>s", fzf.lsp_document_symbols, opts)
            vim.keymap.set("n", "<space>S", fzf.lsp_workspace_symbols, opts)
            vim.keymap.set("n", "gr", fzf.lsp_references, opts)
        end,
    })
end
