vim.opt.spell = true
vim.opt.wrap = true

vim.keymap.set("n", "<leader>tw", function()
	local filename = vim.fn.expand("%")
	if vim.fn.fnamemodify(filename, ":e") == "typ" then
		vim.fn.jobstart({ "typst", "watch", filename }, {
			detach = true,
			on_exit = function(job_id, exit_code)
				if exit_code == 0 then
					print("Typst watch stopped")
				else
					print("Typst watch failed with code: " .. exit_code)
				end
			end,
		})
		print("Started typst watch for " .. filename)
	else
		print("Not a Typst file")
	end
end, { desc = "Start typst watch for current file" })
