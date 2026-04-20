local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Color theme
now(function()
	add("folke/tokyonight.nvim")
	require("tokyonight").setup({
		transparent = true,
		styles = {
			sidebars = "transparent",
			floats = "transparent",
		},
	})
	vim.cmd([[colorscheme tokyonight]])
end)

-- Treesitter
now(function()
	add({ source = "nvim-treesitter/nvim-treesitter", checkout = "master" })
	require("nvim-treesitter.configs").setup({
		ensure_installed = {
			"rust",
			"go",
			"javascript",
			"typescript",
			"tsx",
			"lua",
			"json",
			"html",
			"css",
			"markdown",
			"typst",
			"toml",
			"python",
			"make",
		},
		auto_install = true,
		highlight = { enable = true },
		indent = { enable = true },
	})

	add({
		source = "nvim-treesitter/nvim-treesitter-textobjects",
		checkout = "main",
	})

	-- Prefer bun
	vim.lsp.config("ts_ls", {
		cmd = { "bun", "run", "--bun", "typescript-language-server", "--stdio" },
	})
	vim.lsp.config("tailwindcss", {
		cmd = { "bun", "run", "--bun", "tailwindcss-language-server", "--stdio" },
	})
	vim.lsp.config("emmet_ls", {
		cmd = { "bun", "run", "--bun", "emmet-ls", "--stdio" },
	})
end)

now(function()
	add("folke/snacks.nvim")
	require("snacks").setup({})
end)

-- Auto pairs for HTML/JSX tags
later(function()
	add("windwp/nvim-ts-autotag")
	require("nvim-ts-autotag").setup({
		opts = {
			enable_close = true,
			enable_rename = true,
			enable_close_on_slash = true,
		},
	})
end)

-- LSP, Completion, Formatting
later(function()
	-- Mute LSP progress notifications
	vim.lsp.handlers["$/progress"] = function() end

	-- LSP configs
	add("neovim/nvim-lspconfig")

	-- LSP installer
	add("williamboman/mason.nvim")
	require("mason").setup({})

	-- Setup LSPs
	add("williamboman/mason-lspconfig.nvim")
	require("mason-lspconfig").setup({
		ensure_installed = {
			"rust_analyzer",
			"gopls",
			"ts_ls",
			"lua_ls",
			"html",
			"cssls",
			"emmet_ls",
			"tailwindcss",
			"tinymist",
			"taplo",
			"ty",
		},
		automatic_installation = true,
	})

	-- Setup formatters
	add("WhoIsSethDaniel/mason-tool-installer.nvim")
	require("mason-tool-installer").setup({
		ensure_installed = {
			"rustfmt",
			"prettierd",
			"stylua",
			"goimports",
			"typstyle",
			"ruff",
		},
	})

	-- Completion
	add({
		source = "saghen/blink.cmp",
		depends = { "rafamadriz/friendly-snippets" },
	})
	require("blink.cmp").setup({
		fuzzy = { implementation = "lua" },
		keymap = { preset = "super-tab" },
	})

	-- Formatting
	add("stevearc/conform.nvim")
	require("conform").setup({
		formatters_by_ft = {
			rust = { "rustfmt" },
			go = { "goimports" },
			lua = { "stylua" },
			typst = { "typstyle" },
			toml = { "taplo" },
			python = { "ruff" },
			["_"] = { "prettier" },
		},
		format_on_save = function()
			-- Only format if it's NOT an autosave
			if vim.g.is_autosave then
				return false
			end
			return { lsp_fallback = true }
		end,
	})
end)

later(function()
	add("rachartier/tiny-inline-diagnostic.nvim")
	require("tiny-inline-diagnostic").setup()
	vim.diagnostic.config({ virtual_text = false })
end)

-- Harpoon
later(function()
	add({ source = "ThePrimeagen/harpoon", checkout = "harpoon2", depends = { "nvim-lua/plenary.nvim" } })
	local harpoon = require("harpoon")

	harpoon:setup()

	-- Add to list
	vim.keymap.set("n", "<leader>a", function()
		harpoon:list():add()
	end)
	-- See menu
	vim.keymap.set("n", "<leader>0", function()
		harpoon.ui:toggle_quick_menu(harpoon:list())
	end)
	-- Tabs 1-4
	vim.keymap.set("n", "<leader>1", function()
		harpoon:list():select(1)
	end)
	vim.keymap.set("n", "<leader>2", function()
		harpoon:list():select(2)
	end)
	vim.keymap.set("n", "<leader>3", function()
		harpoon:list():select(3)
	end)
	vim.keymap.set("n", "<leader>4", function()
		harpoon:list():select(4)
	end)

	-- Toggle previous & next buffers stored within Harpoon list
	vim.keymap.set("n", "<leader>.", function()
		harpoon:list():prev()
	end)
	vim.keymap.set("n", "<leader>,", function()
		harpoon:list():next()
	end)
end)

later(function()
	add("folke/zen-mode.nvim")
	require("zen-mode").setup({
		window = { width = 85 },
	})
	vim.keymap.set("n", "<leader>z", "<cmd>ZenMode<CR>")

	add("folke/which-key.nvim")
	require("which-key").setup({})

	add("https://codeberg.org/andyg/leap.nvim")
	require("leap").setup({})
	vim.keymap.set({ "n", "x", "o" }, "<CR>", "<Plug>(leap)")
end)
