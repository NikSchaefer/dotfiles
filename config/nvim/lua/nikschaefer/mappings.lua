vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Yanks go to your OS clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>Y", [["+Y]], { desc = "Yank to system clipboard" })

-- Deletes without copying to clipboard
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without copying" })

-- Split windows (vim-style directions)
vim.keymap.set("n", "<leader>sh", "<C-w>v", { desc = "Split window left (vertical)" })
vim.keymap.set("n", "<leader>sl", "<C-w>v", { desc = "Split window right (vertical)" })
vim.keymap.set("n", "<leader>sk", "<C-w>s", { desc = "Split window up (horizontal)" })
vim.keymap.set("n", "<leader>sj", "<C-w>s", { desc = "Split window down (horizontal)" })
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
vim.keymap.set("n", "<leader>sx", ":close<CR>", { desc = "Close current split" })

-- Navigate between windows (vim-style hjkl)
vim.keymap.set("n", "<leader>h", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<leader>j", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<leader>k", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<leader>l", "<C-w>l", { desc = "Move to right window" })
