-- https://github.com/folke/which-key.nvim?tab=readme-ov-file#lazynvim
return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	dependencies = {
		{ "echasnovski/mini.icons", version = "*" },
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Local Keymaps (which-key)",
		},
	},
}
