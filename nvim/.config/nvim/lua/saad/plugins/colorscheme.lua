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
--

return {
	"sainnhe/sonokai",
	name = "sonokai",
	priority = 1000, -- Garante que o tema carregue antes de outros plugins
	config = function()
		-- Define o estilo do Sonokai
		-- Opções: 'default', 'atlantis', 'andromeda', 'shusia', 'maia', 'espresso'
		vim.g.sonokai_style = "andromeda"

		-- (Opcional) Ajustes de performance e contraste
		vim.g.sonokai_better_performance = 1
		vim.g.sonokai_enable_italic = 1
		vim.g.sonokai_transparent_background = 0 -- Mude para 1 se quiser fundo transparente

		-- (Opcional) Ajustar contraste de certos elementos
		-- vim.g.sonokai_diagnostic_text_highlight = 1
		-- vim.g.sonokai_diagnostic_line_highlight = 1
		-- vim.g.sonokai_diagnostic_virtual_text = "colored"

		-- Carrega o esquema de cores
		vim.cmd.colorscheme("sonokai")
	end,
}
