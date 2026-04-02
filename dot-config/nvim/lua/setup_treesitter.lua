local function any(table)
	for _ in pairs(table) do
		return true
	end
	return false
end

local function contains(table, needle)
	for _, hay in pairs(table) do
		if hay == needle then
			return true
		end
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

	local available = ts.get_available()

	local callback = function()
		-- syntax highlighting, provided by Neovim
		vim.treesitter.start()
		-- folds, provided by Neovim
		vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		-- indentation, provided by nvim-treesitter
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end

	-- automatically install missing parsers
	vim.api.nvim_create_autocmd("FileType", {
		callback = function(args)
			local ty = args.match
			if contains(available, ty) then
				ts.install({ args.match }):wait()
				vim.api.nvim_create_autocmd("FileType", {
					pattern = { ty },
					callback = callback,
				})
			end
		end,
	})
	vim.api.nvim_create_autocmd("FileType", {
		pattern = supported_filetypes,
		callback = callback,
	})

	vim.keymap.set({ "n" }, "=", "van", { remap = true })
	vim.keymap.set({ "v" }, "=", "an", { remap = true })
	vim.keymap.set({ "v" }, "-", "in", { remap = true })
end
