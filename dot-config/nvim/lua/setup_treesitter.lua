return function()
	local ts = require("nvim-treesitter")
	vim.api.nvim_create_autocmd("FileType", {
		pattern = ts.get_installed(),
		callback = function()
			-- syntax highlighting, provided by Neovim
			vim.treesitter.start()
			-- folds, provided by Neovim
			vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
			-- indentation, provided by nvim-treesitter
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end,
	})
    ts.install({ "lua", "rust", "c", "cpp", "javascript", "typescript", "html", "css" })
	vim.keymap.set({ "n" }, "=", "van", { remap = true })
	vim.keymap.set({ "v" }, "=", "an", { remap = true })
	vim.keymap.set({ "v" }, "-", "in", { remap = true })
end
