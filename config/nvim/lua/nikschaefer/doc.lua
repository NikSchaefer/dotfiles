-- This file is for examples only to help document nvim's lua api
-- Set built in options
vim.opt.number = true

-- Create key maps
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" })

-- Define custom commands
vim.api.nvim_create_user_command("Hello", function()
	print("Hello World")
end)

-- Create an auto command
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function()
		print("This prints went the file saves")
	end,
})
