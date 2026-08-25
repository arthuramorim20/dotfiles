return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master", -- pin to legacy v0.9 API; v1.0 (main) drops nvim-treesitter.configs
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
	},
	config = function()
		-- import nvim-treesitter plugin
		local treesitter = require("nvim-treesitter.configs")

		-- configure treesitter
		treesitter.setup({ -- enable syntax highlighting
			highlight = {
				enable = true,
				-- Remover jinja2 daqui - não existe parser jinja2 no treesitter
				additional_vim_regex_highlighting = { "terraform" },
				disable = { "tmux", "jsonc" },
			},
			-- enable indentation
			indent = { enable = true },
			-- enable autotagging (w/ nvim-ts-autotag plugin)
			autotag = {
				enable = true,
			},
			-- ensure these language parsers are installed
			ensure_installed = {
				"json",
				"javascript",
				"typescript",
				"tsx",
				"yaml",
				"html",
				"css",
				"prisma",
				"markdown",
				"markdown_inline",
				"svelte",
				"graphql",
				"hcl",
				"helm",
				"toml",
				"regex",
				"bash",
				"lua",
				"python",
				"vim",
				"dockerfile",
				"gitignore",
				"query",
				"terraform",
				"vimdoc",
				"c",
				"tmux",
				"htmldjango", -- Para highlighting de Django/Jinja2
			},
			-- Do not download parsers automatically while opening a buffer.
			-- A failed mirror response must not fill the editor with errors.
			auto_install = false,
			sync_install = false,
			ignore_install = {},
			modules = {},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
		})
	end,
}
