-- mini.nvim
local path_package = vim.fn.stdpath('data') .. '/site'
local mini_path = path_package .. '/pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
	vim.cmd('echo "Installing `mini.nvim`" | redraw')
	local clone_cmd = {
		'git', 'clone', '--filter=blob:none',
		'https://github.com/echasnovski/mini.nvim', mini_path
	}
	vim.fn.system(clone_cmd)
	vim.cmd('packadd mini.nvim | helptags ALL')
	vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- vim options
vim.opt.relativenumber = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4

-- mini packages
require("mini.starter").setup({
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
})
require("mini.comment").setup()
require("mini.pick").setup()
require("mini.deps").setup()
require("mini.pairs").setup()
require("mini.icons").setup()
require("mini.statusline").setup()
require('mini.pick').setup({
	mappings = {
		-- Navigation
		move_down = '<C-n>',
		move_up = '<C-p>',

		-- Selection
		choose = '<CR>',
		choose_in_split = '<C-x>',
		choose_in_vsplit = '<C-v>',
		choose_in_tabpage = '<C-t>',

		-- Preview toggle (like telescope)
		toggle_preview = '<Tab>',

		-- Scroll in preview
		scroll_down = '<C-f>',
		scroll_up = '<C-b>',

		-- Mark multiple items
		mark = '<C-q>', -- Similar to telescope's <C-q> for quickfix
		choose_marked = '<M-CR>',
	},

	window = {
		config = function()
			local height = math.floor(0.6 * vim.o.lines)
			local width = math.floor(0.8 * vim.o.columns)
			return {
				anchor = 'NW',
				height = height,
				width = width,
				row = math.floor(0.5 * (vim.o.lines - height)),
				col = math.floor(0.5 * (vim.o.columns - width)),
				border = 'rounded',
			}
		end,
	},
})

-- Minimal LSP setup with mini.deps
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Install plugins
add("neovim/nvim-lspconfig")
add("williamboman/mason.nvim")
add("williamboman/mason-lspconfig.nvim")
add({ "saghen/blink.cmp", version = "1.*" })
add("ggandor/leap.nvim")
add("folke/tokyonight.nvim")
require("tokyonight").setup({
	transparent = true,
	styles = {
		sidebars = "transparent",
		floats = "transparent",
	},
})

vim.cmd [[colorscheme tokyonight]]

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = { "rust_analyzer", "gopls", "ts_ls", "lua_ls" }
})

later(function() require('blink.cmp').setup() end)
later(function()
	-- Format on save
	vim.api.nvim_create_autocmd("BufWritePre", {
		pattern = "*",
		callback = function()
			vim.lsp.buf.format()
		end,
	})
end)

-- keybings
vim.keymap.set('n', '<leader>ff', function() MiniPick.builtin.files() end, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', function() MiniPick.builtin.grep_live() end, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', function() MiniPick.builtin.buffers() end, { desc = 'Find buffers' })
vim.keymap.set('n', '<leader>fh', function() MiniPick.builtin.help() end, { desc = 'Find help' })
