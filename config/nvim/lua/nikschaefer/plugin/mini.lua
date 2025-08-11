local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

add({ name = "mini.nvim" })

-- Mini packages

now(function()
	require("mini.basics").setup()
end)

now(function()
	require("mini.sessions").setup()
end)

now(function()
	require("mini.notify").setup()
end)

now(function()
	require("mini.statusline").setup()
end)

now(function()
	require("mini.tabline").setup()
end)

now(function()
	require("mini.extra").setup()
end)

now(function()
	require("mini.starter").setup({
		autoopen = true,
		header = table.concat({
			"○ → ◐ → ◑ → ◒ → ●",
			"",
			"The most seductive ideology is ",
			"that you have no ideology,",
			"",
		}, "\n"),
		footer = "isn't that kind of an ideology in itself? \n\n~",
		content_hooks = {
			function(content)
				local filtered_content = {}
				local cursor_line = nil

				for i, line in ipairs(content) do
					local filtered_line = {}
					for _, unit in ipairs(line) do
						-- Keep only header and footer content
						if unit.type == "header" or unit.type == "footer" then
							table.insert(filtered_line, unit)
							if unit.type == "header" and unit.string == "The most seductive ideology is " then
								cursor_line = #filtered_content + 6
							end
						end
					end
					-- Only add lines that have actual content
					if #filtered_line > 0 then
						table.insert(filtered_content, filtered_line)
					end
				end

				-- Add an invisible item at the cursor position for positioning
				table.insert(filtered_content[cursor_line], {
					type = "item",
					string = "",
					hl = nil,
					item = { action = "", name = "", section = "" },
				})

				return filtered_content
			end,
			require("mini.starter").gen_hook.aligning("center", "center"),
		},
		silent = true,
		query_updaters = "",
	})
end)

now(function()
	require("mini.animate").setup({
		cursor = {
			enable = false,
		},
	})
end)

-- Lazy loaded Mini packages

later(function()
	require("mini.ai").setup()
end)
later(function()
	require("mini.align").setup()
end)
later(function()
	require("mini.bracketed").setup()
end)
later(function()
	local miniclue = require("mini.clue")
	miniclue.setup({
		window = {
			delay = 0,
		},
		clues = {
			miniclue.gen_clues.builtin_completion(),
			miniclue.gen_clues.g(),
			miniclue.gen_clues.marks(),
			miniclue.gen_clues.registers(),
			miniclue.gen_clues.windows({ submode_resize = true }),
			miniclue.gen_clues.z(),
		},
		triggers = {
			{ mode = "n", keys = "<Leader>" }, -- Leader triggers
			{ mode = "x", keys = "<Leader>" },
			{ mode = "n", keys = [[\]] }, -- mini.basics
			{ mode = "n", keys = "[" }, -- mini.bracketed
			{ mode = "n", keys = "]" },
			{ mode = "x", keys = "[" },
			{ mode = "x", keys = "]" },
			{ mode = "i", keys = "<C-x>" }, -- Built-in completion
			{ mode = "n", keys = "g" }, -- `g` key
			{ mode = "x", keys = "g" },
			{ mode = "n", keys = "'" }, -- Marks
			{ mode = "n", keys = "`" },
			{ mode = "x", keys = "'" },
			{ mode = "x", keys = "`" },
			{ mode = "n", keys = '"' }, -- Registers
			{ mode = "x", keys = '"' },
			{ mode = "i", keys = "<C-r>" },
			{ mode = "c", keys = "<C-r>" },
			{ mode = "n", keys = "<C-w>" }, -- Window commands
			{ mode = "n", keys = "z" }, -- `z` key
			{ mode = "x", keys = "z" },
		},
	})
end)

later(function()
	require("mini.comment").setup()
end)

later(function()
	require("mini.completion").setup()
end)
later(function()
	require("mini.diff").setup()
end)
later(function()
	require("mini.files").setup()
	vim.keymap.set("n", "<leader>e", function()
		local MiniFiles = require("mini.files")
		if MiniFiles.BUF_ID then -- Check if mini.files is currently open
			MiniFiles.close()
		else

            -- Open at root but at this file
			local buf_name = vim.api.nvim_buf_get_name(0)
			local path = (buf_name ~= "" and not buf_name:match("^%w+://")) and buf_name or nil

			local _ = MiniFiles.close() or MiniFiles.open(path, false)
			vim.defer_fn(function()
				MiniFiles.reveal_cwd()
			end, 30)
		end
	end)
end)

later(function()
	require("mini.git").setup()
end)
later(function()
	require("mini.hipatterns").setup()
end)
later(function()
	require("mini.indentscope").setup()
end)
later(function()
	require("mini.jump").setup()
end)
later(function()
	require("mini.jump2d").setup()
end)
later(function()
	require("mini.keymap").setup()
end)

later(function()
	require("mini.move").setup()
end)
later(function()
	require("mini.misc").setup()
end)
later(function()
	require("mini.operators").setup()
end)
later(function()
	require("mini.pairs").setup()
end)
later(function()
	require("mini.icons").setup()
end)

-- Note: Ensure ripgrep is installed on system
later(function()
	require("mini.pick").setup({
		window = {
			config = function()
				local height = math.floor(vim.o.lines * 0.6) -- 60% of screen height
				local relative_width = math.floor(vim.o.columns * 0.8) -- 80% of screen width
				local width = math.min(relative_width, 70)

				return {
					anchor = "NW",
					height = height,
					width = width,
					row = math.floor((vim.o.lines - height) / 2),
					col = math.floor((vim.o.columns - width) / 2),
				}
			end,
		},
	})

	local map = vim.keymap.set
	map("n", "<leader>ff", "<cmd>Pick files<cr>", { desc = "Find Files" })
	map("n", "<leader>fg", "<cmd>Pick grep_live<cr>", { desc = "Live Grep" })
	map("n", "<leader>fb", "<cmd>Pick buffers<cr>", { desc = "Find Buffers" })
	map("n", "<leader>fh", "<cmd>Pick help<cr>", { desc = "Find Help" })
	map("n", "<leader>fr", "<cmd>Pick oldfiles<cr>", { desc = "Recent Files" })
	map("n", "<leader><leader>", "<cmd>Pick files<cr>", { desc = "Find Files" })
end)
later(function()
	require("mini.snippets").setup()
end)
later(function()
	require("mini.splitjoin").setup()
end)
later(function()
	require("mini.surround").setup()
end)
later(function()
	require("mini.trailspace").setup()
end)
