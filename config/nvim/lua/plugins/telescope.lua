return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<D-k>", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
  },
}
