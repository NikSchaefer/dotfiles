vim.opt.nu = true -- Enable line numbers
vim.opt.relativenumber = true -- Use relative line numbers

vim.opt.shortmess:append("I") -- Hide start screen
vim.opt.laststatus = 0 -- Remove status bar

-- Tab preferences
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- 2-space indent for filetypes that conventionally use it
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "typescript", "typescriptreact", "json", "jsonc", "json5" },
	callback = function()
		vim.opt_local.tabstop = 2
		vim.opt_local.shiftwidth = 2
		vim.opt_local.expandtab = true
	end,
})

vim.opt.smartindent = true -- Auto indent
vim.opt.wrap = false -- No wrap
vim.o.ignorecase = true -- Insensitive search
