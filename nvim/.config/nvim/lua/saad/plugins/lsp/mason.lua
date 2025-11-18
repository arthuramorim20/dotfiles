return {
	"williamboman/mason.nvim",
	dependencies = {
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local mason = require("mason")
		local mason_tool_installer = require("mason-tool-installer")

		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		vim.schedule(function()
			mason_tool_installer.setup({
				ensure_installed = {
					-- Formatters
					"prettier",
					"stylua",
					"isort",
					"black",
					"docformatter",
					"ruff",

					-- Linters
					"pylint",
					"djlint",
					"tflint",
				},
				auto_update = false,
				run_on_start = true,
			})
		end)
	end,
}
