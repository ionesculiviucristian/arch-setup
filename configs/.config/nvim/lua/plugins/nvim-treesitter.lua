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
		})
	end,
	lazy = false,
}
