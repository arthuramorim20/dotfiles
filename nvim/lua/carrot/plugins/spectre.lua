return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
		"nvim-pack/nvim-spectre",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local builtin = require("telescope.builtin")

		telescope.setup({
			pickers = {
				find_files = {
					file_ignore_patterns = { ".git", ".venv" },
					hidden = true,
					no_ignore = true,
				},
				live_grep = {
					mappings = {
						i = {
							["<C-h>"] = "to_fuzzy_refine",
						},
					},
					file_ignore_patterns = { ".git", ".venv" },
					additional_args = function(_)
						return { "--hidden" }
					end,
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
				defaults = {
					path_display = { "smart" },
					mappings = {
						i = {
							["<C-k>"] = actions.move_selection_previous,
							["<C-j>"] = actions.move_selection_next,
							["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
						},
					},
				},
			},
		})

		telescope.load_extension("fzf")
		telescope.load_extension("noice")

		-- Spectre setup
		require("spectre").setup({
			color_devicons = true,
			open_cmd = "vnew",
			is_block_ui_break = false,
		})

		-- set keymaps
		local keymap = vim.keymap
		keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
		keymap.set("n", "<leader>fr", "<cmd>Telescope registers<cr>", { desc = "Fuzzy find registers" })
		keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
		keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
		keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
		keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "[F]ind [K]eymaps" })
		keymap.set("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", { desc = "[F]ind [D]iagnostics" })
		keymap.set("n", "<leader>sr", builtin.live_grep, { desc = "Live grep search and replace" })

		-- Spectre keymaps
		keymap.set("n", "<leader>W", "<cmd>Spectre<cr>", { desc = "Open Spectre" })
		keymap.set("n", "<leader>ww", "<cmd>Spectre<cr>", { desc = "Spectre search word" })
		keymap.set("v", "<leader>ww", "<esc><cmd>Spectre<cr>", { desc = "Spectre search selection" })

		keymap.set("n", "<leader><leader>", "<cmd>Telescope buffers<cr>", { desc = "find existing buffers" })
	end,
}
