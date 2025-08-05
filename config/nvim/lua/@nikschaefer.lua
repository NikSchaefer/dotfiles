-- Setup LazyVim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- LazyVim Config
require("lazy").setup({
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    { import = "plugins" },
  },
  defaults = {
    version = "*",
  },
  install = { colorscheme = { "tokyonight" } },
  checker = {
    enabled = true,
    notify = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- Mini config
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
