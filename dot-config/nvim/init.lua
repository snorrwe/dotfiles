local HOME = vim.env.HOME .. "/.config/nvim"

vim.o.termguicolors = true
vim.g.mapleader = ","
vim.g.python3_host_prog = HOME .. "/python3/bin/python"

-- bootstrap lazy
--
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")

vim.opt.incsearch = true
vim.opt.smartindent = true
vim.o.completeopt = "menuone,noselect"

vim.cmd([[set nocompatible]])
vim.cmd([[filetype plugin indent on]])
-- show existing tab with 4 spaces width
vim.cmd([[set tabstop=4]])
-- when indenting with '>', use 4 spaces width
vim.cmd([[set shiftwidth=4]])
-- On pressing tab, insert 4 spaces
vim.cmd([[set expandtab]])
vim.opt.autoread = true

vim.cmd([[set number]])
vim.cmd([[set relativenumber]])
vim.cmd([[set ignorecase]])
vim.cmd([[set smartcase]])
vim.cmd([[set list]])

vim.keymap.set("v", "//", 'y/<C-R>"<cr>')

-- show the next match in the middle of the screen
vim.cmd([[noremap n nzz]])
vim.cmd([[noremap N Nzz]])
vim.keymap.set("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<cr>")
vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>")
vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>")

vim.cmd([[autocmd User LspProgressUpdate redrawstatus]])

vim.opt.scrolloff = 8 -- always have at least 8 lines in the bottom when scrolling
vim.opt.signcolumn = "yes"

vim.opt.diffopt = "filler,internal,closeoff,algorithm:histogram,context:5,linematch:60"

-- move highlightes stuff
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- wgsl
local wgsl_group = vim.api.nvim_create_augroup("wgsl", { clear = true })
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile", "VimEnter" }, {
    pattern = { "*.wgsl" },
    group = wgsl_group,
    command = "set ft=wgsl",
})
-- templ
local templ_group = vim.api.nvim_create_augroup("templ", { clear = true })
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile", "VimEnter" }, {
    pattern = { "*.templ" },
    group = templ_group,
    command = "set ft=templ",
})
-- nushell
local nushell_group = vim.api.nvim_create_augroup("nushell", { clear = true })
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "VimEnter" }, {
    pattern = { "*.nu" },
    group = nushell_group,
    callback = function(ev)
        if vim.fn.executable("nu") == 1 then
            vim.cmd([[LspStart nushell]])
        end
    end,
})

if vim.fn.has("nvim-0.10") == 1 then
    -- enable inlay hints on lsp attach
    vim.api.nvim_create_augroup("LspAttach_inlayhints", { clear = true })
    vim.api.nvim_create_autocmd("LspAttach", {
        group = "LspAttach_inlayhints",
        callback = function(args)
            if not (args.data and args.data.client_id) then
                return
            end

            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client.server_capabilities.inlayHintProvider then
                vim.lsp.inlay_hint.enable(true)
            end
        end,
    })
end

-- highlight when yanking
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight yanked text",
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank({ timeout = 200 })
    end,
})

-- Oil is lazy initialized so I put the keymap here instead of config()
vim.keymap.set("n", "<leader>o", "<cmd>Oil<CR>")

vim.api.nvim_create_user_command("Today", 'r! date +"\\%B \\%d, \\%Y"', {})
vim.api.nvim_create_user_command("Now", "r! date", {})

require("term")
require("pair")
require("format_on_save")
