-- https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#installation
return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			-- https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#supported-languages
			ensure_installed = {
				"bash",
				"css",
				"html",
				"javascript",
				"json",
				"markdown",
				"markdown_inline",
				"php",
				"python",
				"scss",
				"sql",
				"toml",
				"tsx",
				"typescript",
				"vue",
				"xml",
				"yaml",
			},
			auto_install = false,
			highlight = { enable = true },
			indent = { enable = true },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
		})
	end,
	lazy = false,
}
