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

-- LSP & Completion
now(function()
	add("williamboman/mason.nvim")
	require("mason").setup()
end)

now(function()
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
	})
end)

now(function()
	add("WhoIsSethDaniel/mason-tool-installer.nvim")
	require("mason-tool-installer").setup({
		ensure_installed = {
			"rustfmt",
			"gopls",
			"prettierd",
			"stylua",
		},
	})
end)

-- Conform for formatting
later(function()
	add("stevearc/conform.nvim")
	require("conform").setup({
		formatters_by_ft = {
			rust = { "rustfmt" },
			go = { "gofmt" },
			javascript = { "prettierd" },
			typescript = { "prettierd" },
			javascriptreact = { "prettierd" },
			typescriptreact = { "prettierd" },
			lua = { "stylua" },
		},
		format_on_save = {
			lsp_fallback = true,
		},
	})
end)

later(function()
	add({
		source = "neovim/nvim-lspconfig",
		depends = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
	})
end)
later(function()
	add({
		source = "saghen/blink.cmp",
		depends = { add("rafamadriz/friendly-snippets") },
	})
	require("blink.cmp").setup({
		fuzzy = {
			implementation = "lua",
		},
	})
end)

-- Setup LSP
later(function()
	local lsp = require("lspconfig")
	local capabilities = require("blink.cmp").get_lsp_capabilities()

	-- Simple keymaps on LSP attach
	local on_attach = function(client, bufnr)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition", buffer = bufnr })
		vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "More information", buffer = bufnr })
		vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go to references", buffer = bufnr })
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename", buffer = bufnr })
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action", buffer = bufnr })
		vim.keymap.set("n", "<leader>s", function()
			require("conform").format()
		end, { desc = "Format file", buffer = bufnr })
	end

	-- Setup servers with minimal config
	local servers = { "rust_analyzer", "gopls", "ts_ls", "lua_ls" }

	for _, server in ipairs(servers) do
		lsp[server].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})
	end
end)

-- Autosave
later(function()
	add("brianhuster/autosave.nvim")
	require("autosave").setup()
end)
