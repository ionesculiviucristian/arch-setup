-- https://github.com/catppuccin/nvim?tab=readme-ov-file#installation
return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		-- https://github.com/catppuccin/nvim?tab=readme-ov-file#configuration
		require("catppuccin").setup({
			auto_integrations = true,
			flavour = "mocha",
			transparent_background = true,
		})

		vim.cmd.colorscheme("catppuccin")
	end,
}
