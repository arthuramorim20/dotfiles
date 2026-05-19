-- ~/dotfiles/nvim/lua/config/avante.lua
-- Configurações completas do Avante.nvim

local status_ok, avante = pcall(require, "avante")
if not status_ok then
	vim.notify("Avante.nvim não encontrado!", vim.log.levels.ERROR)
	return
end

-- Carrega a chave do arquivo secrets.lua
local secrets = require("secrets")

avante.setup({
	-- ============================================
	-- CONFIGURAÇÃO DO PROVIDER (OpenAI)
	-- ============================================
	provider = "openai",
	auto_suggestions_provider = "openai",

	openai = {
		endpoint = "https://api.openai.com/v1",
		model = "gpt-4o", -- GPT-5!
		timeout = 30000, -- Timeout em ms
		temperature = 0.2,
		max_tokens = 8192, -- GPT-5 suporta mais tokens
		stream = true,
		["local"] = false,
	},

	-- ============================================
	-- CONFIGURAÇÃO DE COMPORTAMENTO
	-- ============================================
	behaviour = {
		auto_suggestions = false, -- MANTENHA FALSE - tem bugs quando true
		auto_set_highlight_group = true,
		auto_set_keymaps = true,
		auto_apply_diff_after_generation = false,
		support_paste_from_clipboard = false,
	},

	-- ============================================
	-- MAPEAMENTOS DE TECLAS
	-- ============================================
	mappings = {
		--- @class AvanteConflictMappings
		diff = {
			ours = "co",
			theirs = "ct",
			all_theirs = "ca",
			both = "cb",
			cursor = "cc",
			next = "]x",
			prev = "[x",
		},
		suggestion = {
			accept = "<M-l>",
			next = "<M-]>",
			prev = "<M-[>",
			dismiss = "<C-]>",
		},
		jump = {
			next = "]]",
			prev = "[[",
		},
		submit = {
			normal = "<CR>",
			insert = "<C-s>",
		},
		sidebar = {
			switch_windows = "<Tab>",
			reverse_switch_windows = "<S-Tab>",
		},
	},

	-- ============================================
	-- CONFIGURAÇÕES DE UI
	-- ============================================
	hints = { enabled = true },

	windows = {
		---@type "right" | "left" | "top" | "bottom"
		position = "right", -- posição da sidebar
		wrap = true, -- similar to vim.o.wrap
		width = 30, -- largura padrão (% ou número absoluto)
		sidebar_header = {
			align = "center", -- left, center, right
			rounded = true,
		},
	},

	highlights = {
		---@type AvanteConflictHighlights
		diff = {
			current = "DiffText",
			incoming = "DiffAdd",
		},
	},

	--- @class AvanteConflictUserConfig
	diff = {
		autojump = true,
		---@type string | fun(): any
		list_opener = "copen",
	},
})

-- ============================================
-- CONFIGURAR API KEY DO OPENAI
-- ============================================
-- O Avante usa variáveis de ambiente
vim.env.OPENAI_API_KEY = secrets.openai_api_key

-- ============================================
-- COMANDOS PERSONALIZADOS EM PORTUGUÊS
-- ============================================

-- Comando para abrir o Avante
vim.api.nvim_create_user_command("AvanteAbrir", function()
	vim.cmd("AvanteAsk")
end, {})

-- Comando para explicar código
vim.api.nvim_create_user_command("AvanteExplicar", function()
	vim.cmd("AvanteAsk Explique este código em português do Brasil de forma clara e didática")
end, { range = true })

-- Comando para otimizar código
vim.api.nvim_create_user_command("AvanteOtimizar", function()
	vim.cmd("AvanteAsk Otimize este código mantendo a funcionalidade. Explique as mudanças em português")
end, { range = true })

-- Comando para encontrar bugs
vim.api.nvim_create_user_command("AvanteBugs", function()
	vim.cmd("AvanteAsk Analise este código e identifique possíveis bugs, erros ou problemas. Liste em português")
end, { range = true })

-- Comando para adicionar comentários
vim.api.nvim_create_user_command("AvanteComentar", function()
	vim.cmd(
		"AvanteAsk Adicione comentários detalhados em português a este código. Retorne APENAS o código comentado"
	)
end, { range = true })

-- Comando para criar testes
vim.api.nvim_create_user_command("AvanteTestes", function()
	vim.cmd("AvanteAsk Crie testes unitários completos para este código. Use as melhores práticas")
end, { range = true })

-- Comando para refatorar
vim.api.nvim_create_user_command("AvanteRefatorar", function()
	vim.cmd("AvanteAsk Refatore este código seguindo as melhores práticas. Explique as mudanças em português")
end, { range = true })

-- Comando para documentar
vim.api.nvim_create_user_command("AvanteDocumentar", function()
	vim.cmd(
		"AvanteAsk Crie documentação completa para este código. Inclua descrição, parâmetros, retorno e exemplos em português"
	)
end, { range = true })

-- Comando para simplificar
vim.api.nvim_create_user_command("AvanteSimplificar", function()
	vim.cmd(
		"AvanteAsk Simplifique este código mantendo a funcionalidade. Torne-o mais legível. Responda em português"
	)
end, { range = true })

-- ============================================
-- KEYMAPS
-- ============================================
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Abrir/Fechar Avante sidebar
keymap("n", "<leader>aa", "<cmd>AvanteToggle<CR>", opts)
keymap("n", "<leader>ar", "<cmd>AvanteRefresh<CR>", opts)

-- Chat e perguntas
keymap("n", "<leader>ak", "<cmd>AvanteAsk<CR>", opts)
keymap("v", "<leader>ak", ":AvanteAsk<CR>", opts)

-- Comandos personalizados (VISUAL MODE APENAS)
keymap("v", "<leader>ae", ":AvanteExplicar<CR>", opts)
keymap("v", "<leader>ao", ":AvanteOtimizar<CR>", opts)
keymap("v", "<leader>ab", ":AvanteBugs<CR>", opts)
keymap("v", "<leader>ac", ":AvanteComentar<CR>", opts)
keymap("v", "<leader>at", ":AvanteTestes<CR>", opts)
keymap("v", "<leader>af", ":AvanteRefatorar<CR>", opts)
keymap("v", "<leader>ad", ":AvanteDocumentar<CR>", opts)
keymap("v", "<leader>as", ":AvanteSimplificar<CR>", opts)

-- Editar código com IA (VISUAL MODE)
keymap("v", "<leader>ai", ":AvanteEdit<CR>", opts)

-- Navegar entre sugestões
keymap("n", "<leader>an", "<cmd>AvanteNext<CR>", opts)
keymap("n", "<leader>ap", "<cmd>AvantePrev<CR>", opts)

vim.notify("Avante.nvim configurado com sucesso!", vim.log.levels.INFO)
