return {
	{
		"scrooloose/nerdcommenter",
		config = function()
			-- NERDcommenter
			vim.g.NERDSpaceDelims = 1

			-- Use compact syntax for prettified multi-line comments
			vim.g.NERDCompactSexyComs = 1

			-- Align line-wise comment delimiters flush left instead of following code indentation
			vim.g.NERDDefaultAlign = "left"

			-- Allow commenting and inverting empty lines (useful when commenting a region)
			vim.g.NERDCommentEmptyLines = 1

			-- Enable trimming of trailing whitespace when uncommenting
			vim.g.NERDTrimTrailingWhitespace = 1
		end,
	},
	{
		"kyazdani42/nvim-tree.lua",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("nvim-tree").setup({
				update_cwd = true,
			})

			vim.keymap.set("n", "<leader>n", "<cmd>NvimTreeToggle<CR>")
			vim.keymap.set("n", "<leader>f", "<cmd>NvimTreeFindFile<CR>")
		end,
	},
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		cmd = "Oil",
		config = function()
			require("oil").setup({
				default_file_explorer = true,
			})
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			-- lualine should only run config after nightfox has been setup
			"EdenEast/nightfox.nvim",
		},
		config = function()
			require("config_lualine")
		end,
	},
	{
		"editorconfig/editorconfig-vim",
		event = "InsertEnter",
	},
	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		dependencies = { "nvim-tree/nvim-web-devicons" },
		-- TODO: rename
		config = require("setup_fzf"),
	},

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufRead", "BufEnter", "VimEnter" },
		cmd = {
			"TSInstall",
			"TSInstallInfo",
			"TSInstallSync",
			"TSUninstall",
			"TSUpdate",
			"TSUpdateSync",
			"TSDisableAll",
			"TSEnableAll",
		},
		config = require("setup_treesitter"),
		dependencies = {
			{
				"nvim-treesitter/nvim-treesitter-textobjects",
			},
			{
				-- show context
				"nvim-treesitter/nvim-treesitter-context",
				config = function()
					require("treesitter-context").setup({
						enable = true,
						max_lines = 8,
						multiline_threshold = 4,
					})
				end,
			},
		},
	},
	{
		"EdenEast/nightfox.nvim",
		config = require("setup_nightfox").config,
		build = require("setup_nightfox").build,
	},
	{
		"airblade/vim-gitgutter",
		event = "VeryLazy",
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			require("which-key").setup({
				triggers = {
					{ "<auto>", mode = "nixsotc" },
				},
			})
		end,
	},
	{
		-- better in-buffer search
		"junegunn/vim-slash",
		event = "VeryLazy",
	},
	{
		"gerw/vim-latex-suite",
		ft = "tex",
	},
	{
		"neovim/nvim-lspconfig",
		config = require("setup_lsp"),
		dependencies = {
			-- LSP Support
			"saghen/blink.cmp",
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"p00f/clangd_extensions.nvim",
			{
				"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
				config = function()
					require("lsp_lines").setup()
					-- Disable virtual_text since it's redundant due to lsp_lines.
					vim.diagnostic.config({
						virtual_text = false,
					})
				end,
			},
			"ibhagwan/fzf-lua",
		},
	},
	-- Autocompletion
	{
		"saghen/blink.cmp",
		-- optional: provides snippets for the snippet source
		dependencies = { "rafamadriz/friendly-snippets" },

		-- use a release tag to download pre-built binaries
		version = "1.*",
		-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
			-- 'super-tab' for mappings similar to vscode (tab to accept)
			-- 'enter' for enter to accept
			-- 'none' for no mappings
			--
			-- All presets have the following mappings:
			-- C-space: Open menu or open docs if already open
			-- C-n/C-p or Up/Down: Select next/previous item
			-- C-e: Hide menu
			-- C-k: Toggle signature help (if signature.enabled = true)
			--
			-- See :h blink-cmp-config-keymap for defining your own keymap
			keymap = {
				preset = "enter",
			},
			cmdline = {
				enabled = false,
			},

			appearance = {
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			completion = { documentation = { auto_show = true } },

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
				per_filetype = {
					sql = { "snippets", "dadbod", "buffer", "path" },
				},
				providers = {
					dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
				},
			},
			snippets = { preset = "luasnip" },

			-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
			-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
			-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
			--
			-- See the fuzzy documentation for more information
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},
	{
		"christoomey/vim-tmux-navigator",
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {},
        -- stylua: ignore
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
            {
                "S",
                mode = { "n", "x", "o" },
                function() require("flash").treesitter() end,
                desc =
                "Flash Treesitter"
            },
            {
                "r",
                mode = "o",
                function() require("flash").remote() end,
                desc =
                "Remote Flash"
            },
            {
                "R",
                mode = { "o", "x" },
                function() require("flash").treesitter_search() end,
                desc =
                "Treesitter Search"
            },
        },
	},
	{
		-- autoformat
		"stevearc/conform.nvim",
		event = "VeryLazy",
		opts = {},
		config = require("setup_conform"),
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			signs = false,
			search = {
				command = "rg",
				args = {
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
				},
				pattern = [[\b(KEYWORDS)]],
			},
		},
	},
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		config = require("setup_snippets"),
	},
	{
		"sindrets/diffview.nvim",
		event = "VeryLazy",
		config = function()
			local dv = require("diffview")
			dv.setup({
				enhanced_diff_hl = true,
				file_panel = {
					listing_style = "list",
				},
			})
			vim.keymap.set("n", "<leader>dh", "<cmd>DiffviewFileHistory<cr>")
			vim.keymap.set("n", "<leader>dc", "<cmd>DiffviewClose<cr>")
			vim.keymap.set("n", "<leader>dr", "<cmd>DiffviewRefresh<cr>")
			vim.keymap.set("n", "<leader>do", "<cmd>DiffviewOpen<cr>")
		end,
	},
	{
		"tpope/vim-dadbod",
		"kristijanhusak/vim-dadbod-ui",
		{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
	},
	{
		"FabijanZulj/blame.nvim",
		config = function()
			require("blame").setup()
		end,
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			sign = { enabled = false },
		},
	},
}
