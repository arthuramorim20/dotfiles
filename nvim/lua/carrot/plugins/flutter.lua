return {
	"akinsho/flutter-tools.nvim",
	ft = { "dart" },
	dependencies = { "nvim-lua/plenary.nvim", "stevearc/dressing.nvim" },
	config = function()
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		require("flutter-tools").setup({
			-- flutter-tools gerencia o LSP do Dart (dartls) sozinho,
			-- inclusive para projetos Dart puro
			lsp = {
				capabilities = capabilities,
				settings = {
					completeFunctionCalls = true,
					showTodos = true,
				},
			},
		})

		-- Atalhos do Flutter (prefixo <leader>F)
		local map = vim.keymap.set
		map("n", "<leader>Fr", "<cmd>FlutterRun<cr>", { desc = "Flutter: Run" })
		map("n", "<leader>FR", "<cmd>FlutterReload<cr>", { desc = "Flutter: Hot reload" })
		map("n", "<leader>Fs", "<cmd>FlutterRestart<cr>", { desc = "Flutter: Hot restart" })
		map("n", "<leader>Fq", "<cmd>FlutterQuit<cr>", { desc = "Flutter: Quit" })
		map("n", "<leader>Fd", "<cmd>FlutterDevices<cr>", { desc = "Flutter: Devices" })
		map("n", "<leader>Fe", "<cmd>FlutterEmulators<cr>", { desc = "Flutter: Emulators" })
		map("n", "<leader>FD", "<cmd>FlutterDevTools<cr>", { desc = "Flutter: DevTools" })
		map("n", "<leader>Fo", "<cmd>FlutterOutlineToggle<cr>", { desc = "Flutter: Outline" })
		map("n", "<leader>Fl", "<cmd>FlutterLogClear<cr>", { desc = "Flutter: Clear log" })
	end,
}
