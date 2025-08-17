-- https://github.com/akinsho/toggleterm.nvim?tab=readme-ov-file#installation
return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			-- https://github.com/akinsho/toggleterm.nvim?tab=readme-ov-file#setup
			require("toggleterm").setup({
				open_mapping = [[<c-\>]],
			})
		end,
	},
}
