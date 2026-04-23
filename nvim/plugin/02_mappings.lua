local map = vim.keymap.set

-- Delete without copying to clipboard
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without copying" })

-- Copy to system keyboard
map({'n', 'x'}, 'gy', '"+y', { desc = "Copy to system clipboard" })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window" })

-- Window management
map("n", "<leader>wh", "<C-w>v<C-w>h", { desc = "Split Left" })
map("n", "<leader>wj", "<C-w>s", { desc = "Split Below" })
map("n", "<leader>wk", "<C-w>s<C-w>k", { desc = "Split Above" })
map("n", "<leader>wl", "<C-w>v", { desc = "Split Right" })
map("n", "<leader>wd", "<C-w>c", { desc = "Delete Window" })
map("n", "<leader>we", "<C-w>=", { desc = "Equalize Windows" })
map("n", "<leader>w+", "<cmd>resize +5<cr>", { desc = "Grow Height" })
map("n", "<leader>w-", "<cmd>resize -5<cr>", { desc = "Shrink Height" })
map("n", "<leader>w>", "<cmd>vertical resize +5<cr>", { desc = "Grow Width" })
map("n", "<leader>w<", "<cmd>vertical resize -5<cr>", { desc = "Shrink Width" })

-- Navigate buffers
map("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer", silent = true })
map("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer", silent = true })
map("n", "<leader>bd", ":bd<CR>", { desc = "Close current buffer", silent = true })
map("n", "<leader>bo", ":%bd|e#|bd#<CR>", { desc = "Close all other buffers", silent = true })

-- Explore
map("n", "<leader>e", function() require("mini.files").open() end, { desc = "Mini Files" })
map("n", "<leader>x", function() require("snacks").explorer() end, { desc = "Snacks Explorer" })

-- Find
map("n", "<leader><leader>", function() require("snacks").picker.smart() end, { desc = "Smart Picker" })
map("n", "<leader>ff", function() require("snacks").picker.files() end, { desc = "Find Files" })
map("n", "<leader>fp", function() require("snacks").picker.projects() end, { desc = "Projects" })
map("n", "<leader>fc", function() require("snacks").picker.files({ cwd = vim.fn.stdpath("config") }) end, { desc = "Find Config Files" })
map("n", "<leader>fs", function() require("snacks").picker() end, { desc = "Pick Sources" })
map("n", "<leader>fw", function() require("snacks").picker.grep_word() end, { desc = "Search Word" })
map("n", "<leader>fg", function() require("snacks").picker.grep() end, { desc = "Grep (Root)" })
map("n", "<leader>fk", function() require("snacks").picker.keymaps() end, { desc = "Keymaps" })
map("n", "<leader>fq", function() require("snacks").picker.qflist() end, { desc = "Quickfix List" })
map("n", "<leader>fu", function() require("snacks").picker.undo() end, { desc = "Undo History" })

-- Git
map("n", "<leader>gg", function() require("snacks").lazygit() end, { desc = "LazyGit" })
map("n", "<leader>gl", function() require("snacks").picker.git_log() end, { desc = "Git Log" })
map("n", "<leader>gd", function() require("snacks").picker.git_diff() end, { desc = "Git Diff" })

-- Zen
map("n", "<leader>z", function() require("snacks").zen() end, { desc = "Zen Mode" })

-- Flash
map({"n", "x", "o"}, "<CR>", function () require("flash").jump() end, { desc = "Flash" })

-- Diagnostics
map("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "<leader>lx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
map("n", "<leader>lX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics (Trouble)" })
map("n", "<leader>ls", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols (Trouble)" })
map("n", "<leader>lr", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", { desc = "LSP Definitions / references / ... (Trouble)" })
map("n", "<leader>lq", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })

-- LSP
map("n", "gd", function() require("snacks").picker.lsp_definitions() end, { desc = "Goto Definition" })
map("n", "grr", function() require("snacks").picker.lsp_references() end, { desc = "References" })
map("n", "gy", function() require("snacks").picker.lsp_type_definitions() end, { desc = "Goto Type Definition" })
map("n", "<leader>ss", function() require("snacks").picker.lsp_symbols() end, { desc = "LSP Symbols" })
