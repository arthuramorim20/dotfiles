-- return {
-- 	"catppuccin/nvim",
-- 	name = "catppuccin",
-- 	priority = 1000, -- Garante que o tema carregue antes de outros plugins
-- 	config = function()
-- 		-- Configura o plugin do Catppuccin
-- 		require("catppuccin").setup({
-- 			flavour = "latte", -- O tema claro que você quer!
-- 			background = {
-- 				light = "latte",
-- 				dark = "mocha",
-- 			},
-- 			integrations = {
-- 				cmp = true,
-- 				gitsigns = true,
-- 				nvimtree = true,
-- 				treesitter = true,
-- 				notify = true,
-- 				-- Adicione outras integrações que você usa
-- 			},
-- 		})
--
-- 		-- Carrega o esquema de cores
-- 		vim.cmd.colorscheme("catppuccin")
-- 	end,
-- }

return {
	"rebelot/kanagawa.nvim",
	name = "kanagawa",
	priority = 1000,
	config = function()
		require("kanagawa").setup({
			compile = false,
			undercurl = true,
			commentStyle = { italic = true },
			functionStyle = {},
			keywordStyle = { italic = true },
			statementStyle = { bold = true },
			typeStyle = {},
			transparent = true,
			dimInactive = false,
			terminalColors = true,
			colors = {
				palette = {},
				theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
			},
			overrides = function(colors)
				return {}
			end,
			theme = "wave", -- Tema claro
			background = {
				dark = "wave",
				light = "lotus",
			},
		})

		vim.cmd("colorscheme kanagawa")
	end,
}
