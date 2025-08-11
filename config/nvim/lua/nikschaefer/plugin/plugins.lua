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
	add({
		source = "nvim-treesitter/nvim-treesitter",
		hooks = {
			post_checkout = function()
				vim.cmd("TSUpdate")
			end,
		},
	})
	require("nvim-treesitter.configs").setup({
		ensure_installed = {
			"rust",
			"go",
			"javascript",
			"typescript",
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
		},
		automatic_installation = true,
		handlers = {
			function(server_name)
				local capabilities = require("blink.cmp").get_lsp_capabilities
				require("lspconfig")[server_name].setup({
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
				})
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
		},
	})
end)

later(function()
	add("OXY2DEV/markview.nvim")
	local presets = require("markview.presets")
	require("markview").setup({
		markdown = {
			headings = presets.headings.arrowed,
			tables = presets.tables.rounded,
		},
	})
	require("markview.extras.checkboxes").setup()
	require("markview.extras.editor").setup()
	require("markview.extras.headings").setup()

	vim.keymap.set("n", "<leader>mc", "<cmd>Checkbox interactive<CR>")
	vim.keymap.set("n", "<leader>mt", function()
		vim.api.nvim_put({ "- [ ]" }, "l", true, true)
	end)
end)
