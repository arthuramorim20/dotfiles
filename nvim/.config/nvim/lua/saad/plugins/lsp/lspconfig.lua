return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/nvim-cmp",
		"antosha417/nvim-lsp-file-operations",
		{ "folke/neodev.nvim", opts = {} },
		{
			"rafamadriz/friendly-snippets",
			config = function()
				require("luasnip.loaders.from_vscode").lazy_load()
			end,
		},
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		-- Detecção de versão (mantive sua lógica)
		local use_new_api = vim.fn.has("nvim-0.11") == 1
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		local on_attach = function(client, bufnr)
			local opts = { noremap = true, silent = true, buffer = bufnr }
			vim.keymap.set("n", "<leader>lwl", function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, opts)
		end

		-- Função auxiliar para iniciar o servidor (evita repetição do if/else no código todo)
		local function setup_server(server_name, config)
			config = vim.tbl_deep_extend("force", {
				capabilities = capabilities,
				on_attach = on_attach,
			}, config or {})

			if use_new_api then
				vim.lsp.config[server_name] = config
				vim.lsp.enable(server_name) -- Necessário no 0.11 em alguns casos
			else
				require("lspconfig")[server_name].setup(config)
			end
		end

		-- Configuração de Diagnósticos (Sinais e Ícones)
		local signs = {
			{ name = "DiagnosticSignError", text = "" },
			{ name = "DiagnosticSignWarn", text = "" },
			{ name = "DiagnosticSignHint", text = "󰠠" },
			{ name = "DiagnosticSignInfo", text = "" },
		}

		for _, sign in ipairs(signs) do
			vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
		end

		vim.diagnostic.config({
			virtual_text = true,
			signs = { active = signs }, -- Compatibilidade geral
			update_in_insert = false,
			underline = true,
			severity_sort = true,
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		})

		-- Associações de arquivos
		vim.filetype.add({
			extension = {
				tf = "terraform",
				j2 = "jinja2",
				jinja = "jinja2",
				jinja2 = "jinja2",
			},
		})

		local lspconfig = require("lspconfig")

		-- ### CONFIGURAÇÃO DO MASON-LSPCONFIG ###
		-- Aqui juntamos a instalação e a configuração
		require("mason-lspconfig").setup({
			-- 1. A lista que você tinha antes (recuperei dos seus logs)
			ensure_installed = {
				"ansiblels",
				"bashls",
				"dockerls",
				"docker_compose_language_service",
				"eslint",
				"graphql",
				"helm_ls",
				"html",
				"jsonls",
				"lua_ls",
				"ruff", -- Lembre-se: ruff é linter, ruff_lsp é o antigo LSP (agora ruff faz os dois)
				"sqlls",
				"terraformls",
				"yamlls",
				-- "jinja_lsp", -- Adicione se quiser instalar via Mason
				-- "dartls",    -- Adicione se quiser instalar via Mason
			},

			-- Instala automaticamente se não estiver na lista acima
			automatic_installation = true,

			-- 2. Os Handlers (Configuradores)
			handlers = {
				-- Handler Padrão (Para tudo que não tem config específica)
				function(server_name)
					setup_server(server_name, {})
				end,

				-- Handler Específico: Ansible
				["ansiblels"] = function()
					setup_server("ansiblels", {
						filetypes = { "yaml.ansible" },
						root_dir = lspconfig.util.root_pattern(".ansible-lint", "ansible.cfg", ".git"),
					})
				end,

				-- Handler Específico: Terraform
				["terraformls"] = function()
					setup_server("terraformls", {
						filetypes = { "terraform", "terraform-vars" },
						root_dir = lspconfig.util.root_pattern(".terraform", "*.tf", ".git"),
					})
				end,

				-- Handler Específico: Jinja
				["jinja_lsp"] = function()
					setup_server("jinja_lsp", {
						filetypes = { "jinja2", "jinja" },
						root_dir = lspconfig.util.root_pattern(".git", "requirements.txt", "pyproject.toml"),
						settings = {
							templates = "./templates",
							backend = { "./src", "./app" },
							lang = "python",
						},
					})
				end,

				-- Handler Específico: YAML
				["yamlls"] = function()
					setup_server("yamlls", {
						settings = {
							yaml = {
								schemaStore = {
									enable = false, -- Desativado pois usamos schemastore nvim plugin geralmente
									url = "",
								},
								schemas = require("schemastore").yaml.schemas(), -- Requer plugin 'b0o/schemastore.nvim' se quiser schemas automáticos
							},
						},
					})
				end,

				-- Handler Específico: Lua
				["lua_ls"] = function()
					setup_server("lua_ls", {
						settings = {
							Lua = {
								diagnostics = { globals = { "vim" } },
								workspace = {
									library = {
										[vim.fn.expand("$VIMRUNTIME/lua")] = true,
										[vim.fn.stdpath("config") .. "/lua"] = true,
									},
								},
							},
						},
					})
				end,
			},
		})
	end,
}
