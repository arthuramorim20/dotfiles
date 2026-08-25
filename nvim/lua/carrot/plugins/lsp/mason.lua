return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		-- import mason
		local mason = require("mason")
		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")
		-- enable mason and configure icons
		mason.setup({
			ui = {
				icons = {
					-- Nerd Font glyphs: terminal can't render SVG (see icons/README.md).
					package_installed = "",
					package_pending = "",
					package_uninstalled = "",
				},
			},
		})
		-- Configurar mason-lspconfig ANTES do mason-tool-installer
		mason_lspconfig.setup({
			-- list of servers for mason to install
			ensure_installed = {
				"ansiblels",
				"bashls",
				"cssls",
				"hyprls",
				"lua_ls",
				"jsonls",
				"marksman",
				"systemd-lsp",
				"taplo",
				"yamlls",
			},
			automatic_installation = true,
		})
		-- Aguardar um pouco antes de configurar o tool-installer
		vim.schedule(function()
			mason_tool_installer.setup({
				ensure_installed = {
					"prettier",
					"stylua",
				},
				auto_update = false, -- adicionar esta opção
				run_on_start = true,
			})
		end)
	end,
}
