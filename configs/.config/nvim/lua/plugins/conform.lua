-- https://github.com/stevearc/conform.nvim?tab=readme-ov-file#installation
return {
	"stevearc/conform.nvim",
	opts = {},
	config = function()
		-- https://github.com/stevearc/conform.nvim?tab=readme-ov-file#setup
		require("conform").setup({
			formatters_by_ft = {
				javascript = { "prettierd", "prettier", stop_after_first = true },
			},
		})

		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*",
			callback = function(args)
				require("conform").format({ bufnr = args.buf })
			end,
		})
	end,
}
