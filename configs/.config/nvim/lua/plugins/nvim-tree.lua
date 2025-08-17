-- https://github.com/nvim-tree/nvim-tree.lua/wiki/Installation#lazy
return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("nvim-tree").setup({})
	end,
	keys = {
		{ "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file explorer" },
		{ "<leader>f", "<cmd>NvimTreeFocus<CR>", desc = "Focus file explorer" },
		{ "<leader>F", "<cmd>NvimTreeFindFile<CR>", desc = "Find current file in explorer" },
		{ "<leader>c", "<cmd>NvimTreeCollapse<CR>", desc = "Collapse all folders in explorer" },
	},
}
