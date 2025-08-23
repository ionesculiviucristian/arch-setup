-- https://github.com/stevearc/conform.nvim?tab=readme-ov-file#installation
return {
	"stevearc/conform.nvim",
	-- https://github.com/stevearc/conform.nvim?tab=readme-ov-file#setup
	opts = {
		formatters_by_ft = {
			javascript = { "prettierd", "prettier", stop_after_first = true },
		},
	},
}
