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
	add("nvim-treesitter/nvim-treesitter")
	require("nvim-treesitter.configs").setup({
		ensure_installed = {
			"rust",
			"go",
			"javascript",
			"typescript",
			"tsx",
			"lua",
			"html",
			"css",
			"markdown",
			"markdown_inline",
		},
		auto_install = true,
		highlight = {
			enable = true,
		},
		indent = {
			enable = true,
		},
	})
end)

-- Auto pairs for HTML/JSX tags and general pairs
later(function()
	add("windwp/nvim-autopairs")
	add("windwp/nvim-ts-autotag")

	-- Setup auto-pairs
	require("nvim-autopairs").setup({
		check_ts = true,
		ts_config = {
			lua = { "string" },
			javascript = { "string", "template_string" },
			typescript = { "string", "template_string" },
			tsx = { "string", "template_string" },
			jsx = { "string", "template_string" },
		},
	})
	-- Setup auto-tag for HTML/JSX
	require("nvim-ts-autotag").setup({
		opts = {
			enable_close = true,
			enable_rename = true,
			enable_close_on_slash = true,
		},
	})
end)

-- LSP & Completion
later(function()
	-- Enable lsp configs
	add({
		source = "neovim/nvim-lspconfig",
		depends = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
	})
	-- Installer for LSP, formatters, linters, etc
	add("williamboman/mason.nvim")
	require("mason").setup()
	-- Mute LSP progress notifications
	vim.lsp.handlers["$/progress"] = function() end
	-- Bridge for lsp configs to auto install from mason.nvim
	add({
		source = "williamboman/mason-lspconfig.nvim",
		depends = { "williamboman/mason.nvim" },
	})
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
		},
		automatic_installation = true,
		handlers = {
			function(server_name)
				local capabilities = require("blink.cmp").get_lsp_capabilities()
				local config = {
					capabilities = capabilities,
					on_attach = function(_, bufnr)
						vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition", buffer = bufnr })
						vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "More information", buffer = bufnr })
						vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go to references", buffer = bufnr })
						vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename", buffer = bufnr })
						vim.keymap.set(
							"n",
							"<leader>ca",
							vim.lsp.buf.code_action,
							{ desc = "Code action", buffer = bufnr }
						)
					end,
				}

				require("lspconfig")[server_name].setup(config)
			end,
		},
	})
	-- Ensure installed formatters
	add("WhoIsSethDaniel/mason-tool-installer.nvim")
	require("mason-tool-installer").setup({
		ensure_installed = {
			"rustfmt",
			"prettierd",
			"stylua",
		},
	})
	-- Conform for formatting
	add("stevearc/conform.nvim")
	require("conform").setup({
		formatters_by_ft = {
			rust = { "rustfmt" },
			go = { "gopls" },
			javascript = { "prettierd" },
			typescript = { "prettierd" },
			javascriptreact = { "prettierd" },
			typescriptreact = { "prettierd" },
			html = { "prettierd" },
			css = { "prettierd" },
			lua = { "stylua" },
		},
		format_on_save = function()
			-- Only format if it's NOT an autosave
			if vim.g.is_autosave then
				return false
			end
			return { lsp_fallback = true }
		end,
	})
	vim.keymap.set("n", "<leader>ss", function()
		require("conform").format()
	end, { desc = "Format file" })
end)

later(function()
	add("rachartier/tiny-inline-diagnostic.nvim")
	require("tiny-inline-diagnostic").setup()
	vim.diagnostic.config({
		virtual_text = false, -- tiny-inline-diagnostic replaces this
		signs = true,
		underline = true,
		update_in_insert = false,
	})
end)

later(function()
	add({
		source = "saghen/blink.cmp",
		depends = { "rafamadriz/friendly-snippets" },
	})
	require("blink.cmp").setup({
		fuzzy = {
			implementation = "lua",
		},
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},
		keymap = {
			preset = "default",
			["<Tab>"] = { "accept", "fallback" },
			["<Enter>"] = { "accept", "fallback" },
		},
		completion = {
			trigger = {
				show_on_insert_on_trigger_character = true,
			},
		},
	})
end)

later(function()
	add("fmolke/zen-mode.nvim")
	require("zen-mode").setup({
		window = {
			width = 85,
		},
	})
	vim.keymap.set("n", "<leader>z", "<cmd>ZenMode<CR>")
end)
