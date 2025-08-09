return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<D-k>", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    { "<D-K>", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
  },
  config = function()
    require("telescope").setup({
      defaults = {
        file_ignore_patterns = {
          "node_modules/.*",
          "%.git/.*",
          "%.DS_Store",
          "%.pyc",
          "go/.*",
          "target/.*",
        },
      },
    })
  end,
}
