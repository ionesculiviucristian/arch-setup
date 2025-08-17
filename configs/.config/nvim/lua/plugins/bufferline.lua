-- https://github.com/akinsho/bufferline.nvim?tab=readme-ov-file#installation
return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		-- https://github.com/akinsho/bufferline.nvim/blob/655133c3b4c3e5e05ec549b9f8cc2894ac6f51b3/doc/bufferline.txt#L63
		require("bufferline").setup({})
	end,
}
