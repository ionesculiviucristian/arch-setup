-- https://github.com/kevinhwang91/nvim-ufo?tab=readme-ov-file#installation
return {
	"kevinhwang91/nvim-ufo",
	-- https://github.com/kevinhwang91/nvim-ufo?tab=readme-ov-file#minimal-configuration
	config = function()
		require("ufo").setup({
			provider_selector = function()
				return { "treesitter", "indent" }
			end,
		})
	end,
	dependencies = { "kevinhwang91/promise-async" },
}
