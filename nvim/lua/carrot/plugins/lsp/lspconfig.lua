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
		-- Waybar uses GTK CSS extensions (@colors and alpha()), which are not
		-- valid standard CSS. Keep syntax highlighting, but never attach cssls
		-- to these buffers or show false diagnostics.
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "waybarcss",
			callback = function(args)
				vim.diagnostic.reset(nil, args.buf)
				for _, client in ipairs(vim.lsp.get_clients({ bufnr = args.buf })) do
					if client.name == "cssls" then
						vim.lsp.buf_detach_client(args.buf, client.id)
					end
				end
			end,
		})
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				if vim.bo[args.buf].filetype == "waybarcss" then
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client and client.name == "cssls" then
						vim.lsp.buf_detach_client(args.buf, client.id)
						vim.diagnostic.reset(nil, args.buf)
					end
				end
			end,
		})
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "jsonc",
			callback = function(args)
				-- Use Neovim's built-in JSON syntax for JSONC buffers; the
				-- jsonc Treesitter parser is optional and not required by jsonls.
				vim.bo[args.buf].syntax = "json"
			end,
		})

		-- Verificar se a nova API está disponível
		local use_new_api = vim.fn.has("nvim-0.11") == 1

		if use_new_api then
			-- Nova configuração para Neovim 0.11+
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- Função on_attach para configurar mapeamentos locais
			local on_attach = function(client, bufnr)
				local opts = { noremap = true, silent = true, buffer = bufnr }
				vim.keymap.set("n", "<leader>lwl", function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, opts)
			end

			-- Configuração de diagnósticos
			vim.diagnostic.config({
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "",
						[vim.diagnostic.severity.WARN] = "",
						[vim.diagnostic.severity.HINT] = "󰠠 ",
						[vim.diagnostic.severity.INFO] = "",
					},
				},
			})

			-- Adicionar suporte ao Terraform e Jinja2
			vim.filetype.add({
				extension = {
					tf = "terraform",
					j2 = "jinja2",
					jinja = "jinja2",
					jinja2 = "jinja2",
				},
				pattern = {
					[".*%.j2"] = "jinja2",
					[".*%.jinja"] = "jinja2",
					[".*%.jinja2"] = "jinja2",
					[".*/hypr/.*%.conf"] = "hyprlang",
					[".*/hyprlock/.*%.conf"] = "hyprlang",
					[".*/waybar/layouts/.*"] = "jsonc",
					[".*/waybar/modules/.*"] = "jsonc",
					[".*/waybar/.*%.css"] = "waybarcss",
					[".*/waybar/styles/.*%.css"] = "waybarcss",
					[".*%.service"] = "systemd",
				},
			})
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "waybarcss",
					callback = function(args)
						vim.bo[args.buf].syntax = "css"
					end,
				})

			-- Aguardar a inicialização completa do Mason antes de configurar LSPs
			vim.schedule(function()
				-- Usando a nova API vim.lsp.config

				-- Ansible LSP
				vim.lsp.config.ansiblels = {
					cmd = { "ansible-language-server", "--stdio" },
					filetypes = { "yaml.ansible" },
					root_markers = { ".ansible-lint", "ansible.cfg", ".git" },
					capabilities = capabilities,
					on_attach = on_attach,
				}

				-- Terraform LSP
				vim.lsp.config.terraformls = {
					cmd = { "terraform-ls", "serve" },
					filetypes = { "terraform", "terraform-vars" },
					root_markers = { ".terraform", "*.tf", ".git" },
					capabilities = capabilities,
					on_attach = on_attach,
				}

				-- Jinja LSP
				vim.lsp.config.jinja_lsp = {
					cmd = { "jinja-lsp" },
					filetypes = { "jinja2", "jinja" },
					root_markers = { ".git", "requirements.txt", "pyproject.toml", "setup.py" },
					capabilities = capabilities,
					on_attach = on_attach,
					settings = {
						templates = "./templates",
						backend = { "./src", "./app" },
						lang = "python",
					},
				}

				-- YAML LSP
				vim.lsp.config.yamlls = {
					cmd = { "yaml-language-server", "--stdio" },
					filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
					root_markers = { ".git" },
					capabilities = capabilities,
					on_attach = on_attach,
					settings = {
						yaml = {
							schemaStore = {
								enable = true,
								url = "https://www.schemastore.org/api/json/catalog.json",
							},
							schemas = {
								kubernetes = {
									"*.k8s.yaml",
									"k8s-*.yaml",
									"**/k8s/**/*.yaml",
									"**/kubernetes/**/*.yaml",
								},
								["http://json.schemastore.org/github-workflow"] = {
									".github/workflows/*.yml",
									".github/workflows/*.yaml",
								},
								["http://json.schemastore.org/github-action"] = {
									".github/action.yml",
									".github/action.yaml",
								},
								["http://json.schemastore.org/kustomization"] = {
									"kustomization.yml",
									"kustomization.yaml",
								},
								["http://json.schemastore.org/chart"] = {
									"Chart.yml",
									"Chart.yaml",
								},
							},
							validate = true,
							completion = true,
							hover = true,
							customTags = {
								"!reference sequence",
								"!secret scalar",
							},
						},
					},
				}

				-- LSPs para os formatos usados nos dotfiles.
				vim.lsp.config.bashls = {
					cmd = { "bash-language-server", "start" },
					filetypes = { "sh", "bash", "zsh" },
					root_markers = { ".git" },
					capabilities = capabilities,
					on_attach = on_attach,
				}

				vim.lsp.config.jsonls = {
					cmd = { "vscode-json-language-server", "--stdio" },
					filetypes = { "json", "jsonc" },
					root_markers = { ".git" },
					capabilities = capabilities,
					on_attach = on_attach,
				}

				vim.lsp.config.cssls = {
					cmd = { "vscode-css-language-server", "--stdio" },
					filetypes = { "css", "scss", "less" },
					root_markers = { ".git" },
					capabilities = capabilities,
					on_attach = on_attach,
				}

				vim.lsp.config.hyprls = {
					cmd = { "hyprls", "--stdio" },
					filetypes = { "hyprlang" },
					root_markers = { ".git" },
					capabilities = capabilities,
					on_attach = on_attach,
				}

				vim.lsp.config.systemd_lsp = {
					cmd = { "systemd-lsp" },
					filetypes = { "systemd" },
					root_markers = { ".git" },
					capabilities = capabilities,
					on_attach = on_attach,
				}

				vim.lsp.config.taplo = {
					cmd = { "taplo", "lsp", "stdio" },
					filetypes = { "toml" },
					root_markers = { ".taplo.toml", "pyproject.toml", ".git" },
					capabilities = capabilities,
					on_attach = on_attach,
				}

				vim.lsp.config.marksman = {
					cmd = { "marksman", "server" },
					filetypes = { "markdown", "markdown.mdx" },
					root_markers = { ".git" },
					capabilities = capabilities,
					on_attach = on_attach,
				}

				-- Lua LSP
				vim.lsp.config.lua_ls = {
					cmd = { "lua-language-server" },
					filetypes = { "lua" },
					root_markers = {
						".luarc.json",
						".luarc.jsonc",
						".luacheckrc",
						".stylua.toml",
						"stylua.toml",
						"selene.toml",
						"selene.yml",
						".git",
					},
					capabilities = capabilities,
					on_attach = on_attach,
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim" },
							},
							completion = {
								callSnippet = "Replace",
							},
							workspace = {
								library = vim.api.nvim_get_runtime_file("", true),
								checkThirdParty = false,
							},
							telemetry = {
								enable = false,
							},
						},
					},
				}

				-- Dart LSP
				vim.lsp.config.dartls = {
					cmd = { "dart", "language-server", "--protocol=lsp" },
					filetypes = { "dart" },
					root_markers = { "pubspec.yaml", ".git" },
					capabilities = capabilities,
					on_attach = on_attach,
					settings = {
						dart = {
							completeFunctionCalls = true,
							showTodos = true,
						},
					},
				}

				-- C# LSP (OmniSharp)
				vim.lsp.config.omnisharp = {
					cmd = { "OmniSharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
					filetypes = { "cs", "vb" },
					root_markers = { "*.sln", "*.csproj", "omnisharp.json", "function.json", ".git" },
					capabilities = capabilities,
					on_attach = on_attach,
					settings = {
						FormattingOptions = {
							EnableEditorConfigSupport = true,
							OrganizeImports = true,
						},
						MsBuild = {
							LoadProjectsOnDemand = false,
						},
						RoslynExtensionsOptions = {
							EnableAnalyzersSupport = true,
							EnableImportCompletion = true,
							AnalyzeOpenDocumentsOnly = false,
						},
						Sdk = {
							IncludePrereleases = true,
						},
					},
				}

				-- OBS: o dartls é gerenciado pelo flutter-tools.nvim (plugins/flutter.lua),
				-- por isso NÃO é habilitado aqui (evita LSP duplicado).
			end)
		else
			-- Configuração antiga para versões anteriores ao Neovim 0.11
			local lspconfig = require("lspconfig")
			local cmp_nvim_lsp = require("cmp_nvim_lsp")

			-- Habilidades de autocompletar para todos os LSPs
			local capabilities = cmp_nvim_lsp.default_capabilities()

			-- Função on_attach para configurar mapeamentos locais
			local on_attach = function(client, bufnr)
				local opts = { noremap = true, silent = true, buffer = bufnr }
				vim.keymap.set("n", "<leader>lwl", function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, opts)
			end

			-- Configuração de diagnósticos
			vim.diagnostic.config({
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "",
						[vim.diagnostic.severity.WARN] = "",
						[vim.diagnostic.severity.HINT] = "󰠠 ",
						[vim.diagnostic.severity.INFO] = "",
					},
				},
			})

			-- Adicionar suporte ao Terraform e Jinja2
			vim.filetype.add({
				extension = {
					tf = "terraform",
					j2 = "jinja2",
					jinja = "jinja2",
					jinja2 = "jinja2",
				},
				pattern = {
					[".*%.j2"] = "jinja2",
					[".*%.jinja"] = "jinja2",
					[".*%.jinja2"] = "jinja2",
					[".*/hypr/.*%.conf"] = "hyprlang",
					[".*/hyprlock/.*%.conf"] = "hyprlang",
					[".*/waybar/layouts/.*"] = "jsonc",
					[".*/waybar/modules/.*"] = "jsonc",
					[".*/waybar/.*%.css"] = "waybarcss",
					[".*/waybar/styles/.*%.css"] = "waybarcss",
					[".*%.service"] = "systemd",
				},
			})
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "waybarcss",
				callback = function(args)
					vim.bo[args.buf].syntax = "css"
				end,
			})

			-- Aguardar a inicialização completa do Mason antes de configurar LSPs
			vim.schedule(function()
				-- Configurar LSPs usando lspconfig tradicional (versão antiga)

				-- Ansible LSP
				lspconfig.ansiblels.setup({
					capabilities = capabilities,
					on_attach = on_attach,
				})

				-- Terraform LSP
				lspconfig.terraformls.setup({
					capabilities = capabilities,
					on_attach = on_attach,
				})

				-- Jinja LSP
				lspconfig.jinja_lsp.setup({
					capabilities = capabilities,
					on_attach = on_attach,
					filetypes = { "jinja2", "jinja" },
					root_dir = lspconfig.util.root_pattern(".git", "requirements.txt", "pyproject.toml", "setup.py"),
					settings = {
						templates = "./templates",
						backend = { "./src", "./app" },
						lang = "python",
					},
				})

				-- YAML LSP
				lspconfig.yamlls.setup({
					capabilities = capabilities,
					on_attach = on_attach,
					settings = {
						yaml = {
							schemaStore = {
								enable = true,
								url = "https://www.schemastore.org/api/json/catalog.json",
							},
							schemas = {
								kubernetes = {
									"*.k8s.yaml",
									"k8s-*.yaml",
									"**/k8s/**/*.yaml",
									"**/kubernetes/**/*.yaml",
								},
								["http://json.schemastore.org/github-workflow"] = {
									".github/workflows/*.yml",
									".github/workflows/*.yaml",
								},
								["http://json.schemastore.org/github-action"] = {
									".github/action.yml",
									".github/action.yaml",
								},
								["http://json.schemastore.org/kustomization"] = {
									"kustomization.yml",
									"kustomization.yaml",
								},
								["http://json.schemastore.org/chart"] = {
									"Chart.yml",
									"Chart.yaml",
								},
							},
							validate = true,
							completion = true,
							hover = true,
							customTags = {
								"!reference sequence",
								"!secret scalar",
							},
						},
					},
				})

				lspconfig.bashls.setup({
					capabilities = capabilities,
					on_attach = on_attach,
					filetypes = { "sh", "bash", "zsh" },
				})

				lspconfig.jsonls.setup({
					capabilities = capabilities,
					on_attach = on_attach,
					filetypes = { "json", "jsonc" },
				})

				lspconfig.cssls.setup({
					capabilities = capabilities,
					on_attach = on_attach,
				})

				lspconfig.hyprls.setup({
					capabilities = capabilities,
					on_attach = on_attach,
				})

				lspconfig.systemd_lsp.setup({
					capabilities = capabilities,
					on_attach = on_attach,
				})

				lspconfig.taplo.setup({
					capabilities = capabilities,
					on_attach = on_attach,
				})

				lspconfig.marksman.setup({
					capabilities = capabilities,
					on_attach = on_attach,
				})

				-- Lua LSP
				lspconfig.lua_ls.setup({
					capabilities = capabilities,
					on_attach = on_attach,
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim" },
							},
							completion = {
								callSnippet = "Replace",
							},
							workspace = {
								library = vim.api.nvim_get_runtime_file("", true),
								checkThirdParty = false,
							},
							telemetry = {
								enable = false,
							},
						},
					},
				})

				-- Dart LSP
				lspconfig.dartls.setup({
					capabilities = capabilities,
					on_attach = on_attach,
					settings = {
						dart = {
							completeFunctionCalls = true,
							showTodos = true,
						},
					},
				})
			end)
		end
	end,
}
