-- https://github.com/nvim-lualine/lualine.nvim?tab=readme-ov-file#lazynvim
return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		-- https://github.com/nvim-lualine/lualine.nvim?tab=readme-ov-file#default-configuration
		require("lualine").setup({
			theme = "catppuccin",
		})
	end,
}
