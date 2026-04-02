local function any(table)
	for _ in pairs(table) do
		return true
	end
	return false
end

return function()
	local ts = require("nvim-treesitter")

	local defaults = { "lua", "rust", "c", "cpp", "javascript", "typescript", "html", "css" }

	ts.install(defaults)

	local supported_filetypes = ts.get_installed()

	if not any(supported_filetypes) then
		supported_filetypes = defaults
	end

	vim.api.nvim_create_autocmd("FileType", {
		pattern = supported_filetypes,
		callback = function()
			-- syntax highlighting, provided by Neovim
			vim.treesitter.start()
			-- folds, provided by Neovim
			vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
			-- indentation, provided by nvim-treesitter
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end,
	})

	vim.keymap.set({ "n" }, "=", "van", { remap = true })
	vim.keymap.set({ "v" }, "=", "an", { remap = true })
	vim.keymap.set({ "v" }, "-", "in", { remap = true })
end
