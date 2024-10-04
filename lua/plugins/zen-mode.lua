return {
  "folke/zen-mode.nvim",
  cmd = { "ZenMode" },
  opts = {
    window = {
      width = 85,
      height = 0.95,
      backdrop = 1,
      options = {
        number = false,
        relativenumber = false,
        signcolumn = "no",
        cursorcolumn = false,
      },
    },
    plugins = {
      -- gitsigns = { enabled = false },
      options = {
        laststatus = 3,
      },
    },
  },
  keys = {
    { "<leader>zz", ":ZenMode<cr>", noremap = true, silent = true, desc = "Zen mode" },
  },
}
