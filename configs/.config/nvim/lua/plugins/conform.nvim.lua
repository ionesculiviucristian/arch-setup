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
			javascript = { "prettierd", "prettier", stop_after_first = true },
			vue = { "prettierd", "prettier", stop_after_first = true },
		},
	},
}
