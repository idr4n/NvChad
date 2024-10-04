return {
  "mikavilpas/yazi.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  -- stylua: ignore
  keys = {
    { "-", function() require("yazi").yazi() end, desc = "Open Yazi" },
  },
  opts = {
    open_for_directories = false,
  },
}
