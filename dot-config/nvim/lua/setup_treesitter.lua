return function()
	require("nvim-treesitter.configs").setup({
		ensure_installed = { "lua", "rust", "c", "cpp", "javascript", "typescript", "html", "css" },
		sync_install = false,
		auto_install = true,
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
		autopairs = {
			enable = true,
		},
		indent = {
			enable = true,
		},
		rainbow = {
			enable = true,
		},
		autotag = {
			enable = true,
		},
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "=",
				node_incremental = "=",
				node_decremental = "-",
				scope_incremental = "+",
			},
		},
		textobjects = {
			move = {
				enable = true,
				set_jumps = true,
				goto_next_start = {
					["]m"] = "@function.outer",
				},
				goto_previous_start = {
					["[m"] = "@function.outer",
				},
				goto_next_end = {
					["]M"] = "@function.outer",
				},
				goto_previous_end = {
					["[M"] = "@function.outer",
				},
			},
		},
	})
end
