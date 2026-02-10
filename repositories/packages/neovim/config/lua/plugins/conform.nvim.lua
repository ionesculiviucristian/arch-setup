-- https://github.com/stevearc/conform.nvim?tab=readme-ov-file#installation
return {
	"stevearc/conform.nvim",
	-- https://github.com/stevearc/conform.nvim?tab=readme-ov-file#setup
	opts = {
		format_on_save = {
			timeout_ms = 500,
			lsp_format = "fallback",
		},
		-- https://github.com/stevearc/conform.nvim?tab=readme-ov-file#formatters
		formatters_by_ft = {
			bash = { "shfmt" },
			css = { "prettierd", "prettier", stop_after_first = true },
			go = { "goimports", "gofmt" },
			html = { "prettierd", "prettier", stop_after_first = true },
			javascript = { "prettierd", "prettier", stop_after_first = true },
			javascriptreact = { "prettierd", "prettier", stop_after_first = true },
			json = { "prettierd", "prettier", stop_after_first = true },
			lua = { "stylua" },
			markdown = { "prettierd", "prettier", stop_after_first = true },
			php = { "php_cs_fixer" },
			python = { "black", "isort" },
			scss = { "prettierd", "prettier", stop_after_first = true },
			sh = { "shfmt" },
			typescript = { "prettierd", "prettier", stop_after_first = true },
			typescriptreact = { "prettierd", "prettier", stop_after_first = true },
			vue = { "prettierd", "prettier", stop_after_first = true },
			yaml = { "prettierd", "prettier", stop_after_first = true },
		},
	},
}
