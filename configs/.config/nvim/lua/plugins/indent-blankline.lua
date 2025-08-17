-- https://github.com/lukas-reineke/indent-blankline.nvim?tab=readme-ov-file#install
return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	opts = {},
	config = function()
		-- https://github.com/lukas-reineke/indent-blankline.nvim/blob/005b56001b2cb30bfa61b7986bc50657816ba4ba/doc/indent_blankline.txt#L176
		require("ibl").setup({
			scope = { enabled = false },
		})
	end,
}
