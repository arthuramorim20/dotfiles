return {
	"sainnhe/sonokai",
	priority = 1000,
	config = function()
		vim.o.background = "dark"
		vim.g.sonokai_style = "default"
		vim.g.sonokai_enable_italic = 1
		vim.g.sonokai_better_performance = 1

		vim.cmd.colorscheme("sonokai")
	end,
}
