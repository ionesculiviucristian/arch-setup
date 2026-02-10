-- https://github.com/vuki656/package-info.nvim?tab=readme-ov-file#-installation
return {
	"vuki656/package-info.nvim",
	dependencies = { "MunifTanjim/nui.nvim" },
	event = "BufRead package.json",
	config = true,
	keys = {
		{ "<LEADER>ns", function() require("package-info").show() end, desc = "Show package info" },
		{ "<LEADER>nc", function() require("package-info").hide() end, desc = "Hide package info" },
		{ "<LEADER>nt", function() require("package-info").toggle() end, desc = "Toggle package info" },
		{ "<LEADER>nu", function() require("package-info").update() end, desc = "Update package" },
		{ "<LEADER>nd", function() require("package-info").delete() end, desc = "Delete package" },
		{ "<LEADER>ni", function() require("package-info").install() end, desc = "Install package" },
		{ "<LEADER>np", function() require("package-info").change_version() end, desc = "Change package version" },
	},
}
