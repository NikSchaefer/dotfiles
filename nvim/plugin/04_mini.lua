local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

add({ name = "mini.nvim" })

-- Immediate Mini packages
now(function()
	require("mini.basics").setup()
	require("mini.notify").setup()
	require("mini.tabline").setup()
end)

-- Lazy Mini packages
later(function()
	require("mini.align").setup() -- align text interactively
	require("mini.bracketed").setup() -- bracket navigation
	require("mini.comment").setup() -- toggle comments
	require("mini.diff").setup() -- inline git diffs
	require("mini.cmdline").setup() -- cmd completion
	require("mini.git").setup() -- git integration
	-- require("mini.indentscope").setup() -- animated indent
	require("mini.jump").setup() -- extend f/t jumps
	-- require("mini.jump2d").setup() -- 2d jump labels
	require("mini.move").setup() -- move lines/selections
	require("mini.pairs").setup() -- auto pairs
	require("mini.icons").setup() -- file/ui icons
	require("mini.snippets").setup() -- snippet engine
	require("mini.splitjoin").setup() -- split/join arguments
	require("mini.surround").setup() -- surround text objects
	require("mini.trailspace").setup() -- highlight trailing whitespace
	require("mini.extra").setup() -- extra pickers/textobjects
	require("mini.misc").setup() -- misc utilities
	require("mini.files").setup() -- File selector

	require("mini.operators").setup({ -- custom operators (eval, swap, multiply...)
		replace = { prefix = "cx" }, -- Note: conflicts with lsp mappings without remapping
	})
end)

later(function()
	require("mini.keymap").setup() -- custom keymap helpers
	local map_multistep = require("mini.keymap").map_multistep
	map_multistep("i", "<Tab>", { "pmenu_next" })
	map_multistep("i", "<S-Tab>", { "pmenu_prev" })
	map_multistep("i", "<CR>", { "pmenu_accept", "minipairs_cr" })
	map_multistep("i", "<BS>", { "minipairs_bs" })
end)

later(function()
	local hipatterns = require("mini.hipatterns") -- Highlight patterns
	local hi_words = MiniExtra.gen_highlighter.words
	hipatterns.setup({
		highlighters = {
			fixme = hi_words({ "FIXME", "Fixme", "fixme" }, "MiniHipatternsFixme"),
			hack = hi_words({ "HACK", "Hack", "hack" }, "MiniHipatternsHack"),
			todo = hi_words({ "TODO", "Todo", "todo" }, "MiniHipatternsTodo"),
			note = hi_words({ "NOTE", "Note", "note" }, "MiniHipatternsNote"),
			hex_color = hipatterns.gen_highlighter.hex_color(),
		},
	})
end)

later(function()
	local ai = require("mini.ai") -- Add more text objects
	require("mini.ai").setup({
		custom_textobjects = {
			o = ai.gen_spec.treesitter({ -- code block
				a = { "@block.outer", "@conditional.outer", "@loop.outer" },
				i = { "@block.inner", "@conditional.inner", "@loop.inner" },
			}),
			f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
			c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
			C = ai.gen_spec.treesitter({ a = "@comment.outer", i = "@comment.inner" }), -- comment
			t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
			d = { "%f[%d]%d+" }, -- digits
			e = { -- Word with case
				{ "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
				"^().*()$",
			},
		},
	})
end)

