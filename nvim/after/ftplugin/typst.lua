vim.opt.spell = true
vim.opt.wrap = true

local MiniPairs = require("mini.pairs")

-- Pair $ for math components
MiniPairs.map_buf(0, "i", "$", { action = "closeopen", pair = "$$" })

-- Add a typst watch command
vim.keymap.set("n", "<leader>tw", function()
	local filename = vim.fn.expand("%")
	if vim.fn.fnamemodify(filename, ":e") == "typ" then
		TypstJobId = vim.fn.jobstart({ "typst", "watch", filename }, {
			on_exit = function(job_id, exit_code)
				if exit_code == 0 then
					print("Typst watch stopped")
				else
					print("Typst watch failed with code: " .. exit_code)
				end
				TypstJobId = nil
			end,
		})
		vim.notify("Started typst watch for " .. filename, vim.log.levels.INFO)
	else
		print("Not a Typst file")
	end
end, { desc = "Start typst watch for current file" })
