-- https://github.com/akinsho/bufferline.nvim?tab=readme-ov-file#installation
return {
	"akinsho/bufferline.nvim",
	after = "catppuccin",
	-- https://github.com/akinsho/bufferline.nvim/blob/655133c3b4c3e5e05ec549b9f8cc2894ac6f51b3/doc/bufferline.txt#L63
	config = function()
		require("bufferline").setup({
			highlights = require("catppuccin.special.bufferline").get_theme(),
		})
	end,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	version = "*",
}
