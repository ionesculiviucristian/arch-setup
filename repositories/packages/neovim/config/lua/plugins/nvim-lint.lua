-- https://github.com/mfussenegger/nvim-lint?tab=readme-ov-file#installation
return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			bash = { "shellcheck" },
			go = { "golangcilint" },
			php = { "phpcs" },
			python = { "pylint" },
			sh = { "shellcheck" },
		}

		vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
			callback = function()
				require("lint").try_lint()
			end,
		})
	end,
}
