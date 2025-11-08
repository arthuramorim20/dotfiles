return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		-- Mapear linters por tipo de arquivo
		lint.linters_by_ft = {
			-- JavaScript / TypeScript e frameworks relacionados
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			svelte = { "eslint_d" },
			vue = { "eslint_d" },
			astro = { "eslint_d" },

			-- Web e estilos
			html = { "djlint" },
			css = { "stylelint" },
			scss = { "stylelint" },
			less = { "stylelint" },

			-- Backend
			python = { "pylint" },
			lua = { "luacheck" },
			sh = { "shellcheck", "bashate" },
			bash = { "shellcheck", "bashate" },
			terraform = { "tflint" },
			tf = { "tflint" },

			-- Config / data files
			json = { "jsonlint" },
			yaml = { "yamllint" },

			-- Docs e markdown
			markdown = { "markdownlint" },

			-- Templates (Jinja/Django)
			htmldjango = { "djlint" },
			jinja = { "djlint" },
		}

		-- Configuração personalizada do djlint
		lint.linters.djlint = {
			name = "djlint",
			cmd = "djlint",
			stdin = true,
			args = {
				"--profile",
				"jinja",
				"--lint",
				"--format",
				"json",
				"-",
			},
			stream = "stdout",
			ignore_exitcode = true,
			parser = function(output, bufnr)
				local diagnostics = {}
				local ok, decoded = pcall(vim.json.decode, output)
				if not ok or not decoded then
					return diagnostics
				end

				for _, file_data in pairs(decoded) do
					if file_data.issues then
						for _, issue in ipairs(file_data.issues) do
							local severity = vim.diagnostic.severity.INFO
							if issue.code and string.match(issue.code, "^[EF]") then
								severity = vim.diagnostic.severity.ERROR
							elseif issue.code and string.match(issue.code, "^W") then
								severity = vim.diagnostic.severity.WARN
							elseif issue.code and string.match(issue.code, "^[IH]") then
								severity = vim.diagnostic.severity.HINT
							end

							table.insert(diagnostics, {
								lnum = (issue.line or 1) - 1,
								col = (issue.column or 1) - 1,
								severity = severity,
								message = issue.message or "djlint issue",
								source = "djlint",
								code = issue.code,
							})
						end
					end
				end

				return diagnostics
			end,
		}

		-- Auto lint on events
		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})

		-- Keymap manual para linting
		vim.keymap.set("n", "<leader>l", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })

		-- Comando específico para Jinja
		vim.api.nvim_create_user_command("LintJinja", function()
			lint.try_lint("djlint")
		end, { desc = "Run djlint on current Jinja2 buffer" })
	end,
}
