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
            "markdown_inline",
            "typst",
            "toml",
            "python",
            "make",
        },
        auto_install = true,
        highlight = {
            enable = true,
        },
        indent = {
            enable = true,
        },
    })

    add({
        source = "nvim-treesitter/nvim-treesitter-textobjects",
        checkout = "main",
    })
end)

-- Auto pairs for HTML/JSX tags
later(function()
    add("windwp/nvim-ts-autotag")
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

    -- Completion engine
    add({
        source = "saghen/blink.cmp",
        depends = { "rafamadriz/friendly-snippets" },
    })
    require("blink.cmp").setup({
        fuzzy = { implementation = "lua" },
        keymap = { preset = "super-tab" },
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
            -- "gopls",
            "ts_ls",
            "lua_ls",
            "html",
            "cssls",
            "emmet_ls",
            "tailwindcss",
            "tinymist", -- Typst
            "taplo",    -- TOML
            "ty",       -- Python
        },
        automatic_installation = true,
    })
    -- Ensure installed formatters
    add("WhoIsSethDaniel/mason-tool-installer.nvim")
    require("mason-tool-installer").setup({
        ensure_installed = {
            "rustfmt",
            "prettierd",
            "stylua",
            "goimports",
            "typstyle",
            "ruff", -- Python
        },
    })
    -- Conform for formatting
    add("stevearc/conform.nvim")
    require("conform").setup({
        formatters_by_ft = {
            rust = { "rustfmt" },
            go = { "goimports" },
            javascript = { "prettierd" },
            typescript = { "prettierd" },
            javascriptreact = { "prettierd" },
            typescriptreact = { "prettierd" },
            json = { "prettierd" },
            html = { "prettierd" },
            css = { "prettierd" },
            lua = { "stylua" },
            typst = { "typstyle" },
            toml = { "taplo" },
            python = { "ruff" },
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
    -- Tab 1
    vim.keymap.set("n", "<leader>1", function()
        harpoon:list():select(1)
    end)
    -- Tab 2
    vim.keymap.set("n", "<leader>2", function()
        harpoon:list():select(2)
    end)
    -- Tab 3
    vim.keymap.set("n", "<leader>3", function()
        harpoon:list():select(3)
    end)
    -- Tab 4
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
        window = {
            width = 85,
        },
    })
    vim.keymap.set("n", "<leader>z", "<cmd>ZenMode<CR>")
end)
