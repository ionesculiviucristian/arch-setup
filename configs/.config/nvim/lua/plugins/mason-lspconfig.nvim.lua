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
			"bashls", -- bash-language-server
			"cssls", -- css-lsp
			"docker_compose_language_service", -- docker-compose-language-service
			"docker_language_server", -- docker-language-server
			"dockerls", -- dockerfile-language-server
			"emmet_ls", -- emmet-ls
			"html", -- html-lsp
			"intelephense", -- intelephense
			"jsonls", -- json-lsp
			"lua_ls", -- lua-language-server
			"pylsp", -- python-lsp-server
			"tailwindcss", -- tailwindcss-language-server
			"ts_ls", -- typescript-language-server
			"vue_ls", -- vue-language-server
		},
	},
}
