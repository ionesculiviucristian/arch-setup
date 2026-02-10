-- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim?tab=readme-ov-file#configuration
return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	dependencies = {
		"mason-org/mason.nvim",
	},
	opts = {
		-- https://mason-registry.dev/registry/list
		ensure_installed = {
			-- formatters
			"black",
			"goimports",
			"isort",
			"php-cs-fixer",
			"prettierd",
			"shfmt",
			"stylua",
			-- linters
			"golangci-lint",
			"phpcs",
			"pylint",
			"shellcheck",
		},
	},
}
