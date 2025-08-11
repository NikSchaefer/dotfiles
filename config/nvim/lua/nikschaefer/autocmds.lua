-- Auto-save with 1 second delay after stopping typing
vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
	pattern = "*",
	callback = function()
		-- Clear any existing timer
		if vim.g.autosave_timer then
			vim.fn.timer_stop(vim.g.autosave_timer)
		end
		-- Set a new timer for a second delay
		vim.g.autosave_timer = vim.fn.timer_start(500, function()
			-- Only save if buffer is modified and has a filename
			if vim.bo.modified and vim.fn.expand("%") ~= "" then
				vim.g.is_autosave = true
				vim.cmd("silent! write")
				vim.defer_fn(function()
					vim.g.is_autosave = false
				end, 50)
			end
		end)
	end,
})
