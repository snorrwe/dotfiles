return function()
	local conform = require("conform")
	-- Use a sub-list to run only the first available formatter
	local prettier = { "prettierd", "prettier", stop_after_first = true }
	conform.setup({
		formatters_by_ft = {
			-- Specify a list of formatters to run
			lua = { "stylua" },
			python = { "black" },
			rust = { "rustfmt" },
			go = { "gofmt" },
			javascript = prettier,
			typescript = prettier,
			json = prettier,
			html = prettier,
			css = prettier,
			yaml = prettier,
			yml = prettier,
			markdown = { "markdownlint", "cbfmt" },
			proto = { "buf" },
			gdscript = { "gdformat" },
			nix = { "nixfmt" },
			sql = { "sqlfmt", "sleek" },
			just = { "just" },
		},
		formatters = {},
	})
	vim.api.nvim_create_user_command("Format", function(args)
		local range = nil
		if args.count ~= -1 then
			local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
			range = {
				start = { args.line1, 0 },
				["end"] = { args.line2, end_line:len() },
			}
		end
		conform.format({ async = true, lsp_fallback = "always", range = range })
	end, { range = true })
	vim.keymap.set({ "n", "v" }, "<leader>a", "<cmd>Format<cr>")
end
