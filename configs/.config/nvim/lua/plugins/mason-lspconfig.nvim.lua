-- https://github.com/mason-org/mason-lspconfig.nvim?tab=readme-ov-file#recommended-setup-for-lazynvim
return {
	"mason-org/mason-lspconfig.nvim",
	dependencies = {
		-- https://github.com/mason-org/mason.nvim?tab=readme-ov-file#recommended-setup-for-lazynvim
		{ "mason-org/mason.nvim", opts = {} },
		-- https://github.com/neovim/nvim-lspconfig
		"neovim/nvim-lspconfig",
	},
	-- https://github.com/mason-org/mason-lspconfig.nvim?tab=readme-ov-file#configuration-using-lazynvim
	opts = {
		-- https://github.com/mason-org/mason-registry/tree/main/packages
		ensure_installed = {
			"bashls",
			"docker_compose_language_service",
			"docker_language_server",
			"dockerls",
			"html",
			"intelephense",
			"jsonls",
			"lua_ls",
			"pylsp",
			"tailwindcss",
			"ts_ls",
			"vue_ls",
		},
	},
}
