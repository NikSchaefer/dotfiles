local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

vim.opt.wrap = true

now(function()
	add({
		source = "OXY2DEV/markview.nvim",
		depends = { "nvim-treesitter/nvim-treesitter" },
	})
	require("markview").setup()
	require("markview.extras.checkboxes").setup()
	require("markview.extras.editor").setup()
	require("markview.extras.headings").setup()

	vim.keymap.set({ "n", "v" }, "<leader>me", "<cmd>Checkbox interactive<CR>")

	vim.keymap.set("n", "<leader>ma", "i- [ ] ", { desc = "Insert unchecked markdown task" })

	-- Insert 3-column table header with separator and empty row
	vim.keymap.set("n", "<leader>mth", function()
		vim.api.nvim_put({
			"| Header 1 | Header 2 | Header 3 |",
			"|----------|----------|----------|",
			"|          |          |          |",
		}, "l", true, true)
		vim.api.nvim_feedkeys("j$hhhhhhhhhh", "n", false)
	end, { desc = "Insert table header (3 columns)" })

	-- Insert empty table row with cursor in first cell
	vim.keymap.set("n", "<leader>mtr", function()
		vim.api.nvim_put({ "|          |          |          |" }, "l", true, true)
		vim.api.nvim_feedkeys("$hhhhhhhhhh", "n", false)
	end, { desc = "Insert table row" })

    vim.defer_fn(function ()
        require("zen-mode").toggle()
    end, 1)
end)
