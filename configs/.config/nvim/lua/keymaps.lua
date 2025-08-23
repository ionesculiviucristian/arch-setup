-- buffers
vim.keymap.set("n", "<leader>n", ":bn<cr>", { desc = "Go to [N]ext buffer in buffer list" })
vim.keymap.set("n", "<leader>p", ":bp<cr>", { desc = "Go to [N]th previous buffer in buffer list" })
vim.keymap.set(
	"n",
	"<leader>x",
	":bd<cr>",
	{ desc = "Unload buffer [N] (default: current buffer) and delete it from the buffer list" }
)

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
