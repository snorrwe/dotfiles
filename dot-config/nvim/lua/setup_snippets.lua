return function()
	local ls = require("luasnip")
	ls.config.set_config({
		history = true,
		enable_autosnippets = true,
	})
	vim.keymap.set({ "i", "s" }, "<C-L>", function()
		if ls.expand_or_jumpable() then
			ls.expand_or_jump()
		end
	end, { silent = true })
	vim.keymap.set({ "i", "s" }, "<C-J>", function()
		ls.jump(-1)
	end, { silent = true })
	vim.keymap.set({ "i", "s" }, "<C-E>", function()
		if ls.choice_active() then
			ls.change_choice(1)
		end
	end, { silent = true })

	for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("lua/snippets/*lua", true)) do
		loadfile(ft_path)()
	end
end
