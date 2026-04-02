return function()
	local tso = require("nvim-treesitter-textobjects")

	tso.setup({
		select = {
			lookahead = true,
		},
	})

	local tso_move = require("nvim-treesitter-textobjects.move")

	local modes = { "n", "x", "o" }
	vim.keymap.set(modes, "]m", function()
		tso_move.goto_next_start("@function.outer", "textobjects")
	end)
	vim.keymap.set(modes, "[m", function()
		tso_move.goto_previous_start("@function.outer", "textobjects")
	end)
	vim.keymap.set(modes, "]M", function()
		tso_move.goto_next_end("@function.outer", "textobjects")
	end)
	vim.keymap.set(modes, "[M", function()
		tso_move.goto_previous_end("@function.outer", "textobjects")
	end)
end
