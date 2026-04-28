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
	add("romus204/tree-sitter-manager.nvim")
	require("tree-sitter-manager").setup({
		auto_install = true,
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
			"typst",
			"toml",
			"python",
			"make",
		},
	})
end)

now(function()
	add("folke/snacks.nvim")
	require("snacks").setup({
		indent = { enabled = true },
		lazygit = { enabled = true },
		rename = { enabled = true },
		picker = { enabled = true },
		terminal = { enabled = true },
		explorer = { enabled = true },
		zen = {
			enabled = true,
			win = { width = 90 },
		},
		dashboard = {
			enabled = true,
			sections = {
				{
					align = "center",
					text = {
						{ "e ", hl = "Keyword" },
						{ "^ ", hl = "Operator" },
						{ "(", hl = "Comment" },
						{ "i ", hl = "Function" },
						{ "* ", hl = "Operator" },
						{ "π", hl = "Constant" },
						{ ") ", hl = "Comment" },
						{ "+ ", hl = "Operator" },
						{ "1 ", hl = "Number" },
						{ "= ", hl = "Operator" },
						{ "0", hl = "Number" },
						-- { "G ", hl = "Function" },
						-- { "↔ ", hl = "Operator" },
						-- { "¬", hl = "ErrorMsg" },
						-- { "Prov", hl = "Keyword" },
						-- { "(", hl = "Comment" },
						-- { "⌜G⌝", hl = "String" },
						-- { ")", hl = "Comment" },
					},
				},
			},
		},
	})
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
	-- Add treesitter extended objects
	add("nvim-treesitter/nvim-treesitter-textobjects")

	-- Mute LSP progress notifications
	vim.lsp.handlers["$/progress"] = function() end

	local has_node = vim.fn.executable("node") == 1
	local has_bun = vim.fn.executable("bun") == 1
	local has_node_runtime = has_node or has_bun

	-- Prefer bun
	if has_bun then
		vim.lsp.config("ts_ls", {
			cmd = { "bun", "run", "--bun", "typescript-language-server", "--stdio" },
		})
		vim.lsp.config("tailwindcss", {
			cmd = { "bun", "run", "--bun", "tailwindcss-language-server", "--stdio" },
		})
		vim.lsp.config("emmet_ls", {
			cmd = { "bun", "run", "--bun", "emmet-ls", "--stdio" },
		})
	end

	-- LSP configs
	add("neovim/nvim-lspconfig")

	-- LSP installer
	add("williamboman/mason.nvim")
	require("mason").setup({})

	local lsp_ensure_installed = {
		"rust_analyzer",
		"gopls",
		"lua_ls",
		"html",
		"cssls",
		"tinymist",
		"taplo",
		"ty",
	}
	if has_node_runtime then
		table.insert(lsp_ensure_installed, "ts_ls")
		table.insert(lsp_ensure_installed, "emmet_ls")
		table.insert(lsp_ensure_installed, "tailwindcss")
	end

	-- Setup LSPs
	add("williamboman/mason-lspconfig.nvim")
	require("mason-lspconfig").setup({
		ensure_installed = lsp_ensure_installed,
		automatic_installation = true,
	})

	local tool_ensure_installed = {
		"rustfmt",
		"stylua",
		"goimports",
		"typstyle",
		"ruff",
	}
	if has_node_runtime then
		table.insert(tool_ensure_installed, "prettierd")
	end

	-- Setup formatters
	add("WhoIsSethDaniel/mason-tool-installer.nvim")
	require("mason-tool-installer").setup({
		ensure_installed = tool_ensure_installed,
	})

	-- Completion
	add({
		source = "saghen/blink.cmp",
		depends = { "rafamadriz/friendly-snippets", "saghen/blink.lib" },
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
			["_"] = { "prettierd" },
		},
		format_on_save = function()
			-- Only format if it's NOT an autosave
			if vim.g.is_autosave then
				return false
			end
			return { lsp_fallback = false }
		end,
	})
end)

later(function()
	add("rachartier/tiny-inline-diagnostic.nvim")
	require("tiny-inline-diagnostic").setup()
	vim.diagnostic.config({ virtual_text = false })
end)

-- Arrow
later(function()
	add("otavioschwanck/arrow.nvim")
	require("arrow").setup({
		leader_key = ";",
		buffer_leader_key = "m",
	})
end)

later(function()
	add("folke/which-key.nvim")
	require("which-key").setup({})
	add("folke/flash.nvim")
	require("flash").setup({})
	add("folke/trouble.nvim")
	require("trouble").setup({})
end)
