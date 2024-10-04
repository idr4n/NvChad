return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    -- preset = "modern",
    -- preset = "helix",
    notify = false,
    icons = {
      rules = false,
      separator = "",
    },
    win = {
      -- no_overlap = false,
      -- width = { max = 0.28 },
      height = { min = 4, max = 20 },
    },
  },
  config = function(_, opts)
    -- default config function's stuff
    dofile(vim.g.base46_cache .. "whichkey")
    require("which-key").setup(opts)

    local wk = require "which-key"
    local keymaps_n = {
      ["<leader>"] = {
        b = { name = "buffer" },
        c = { name = "code" },
        g = { name = "git/glance" },
        h = { name = "gitsings" },
        j = { name = "AI" },
        l = { name = "LSP" },
        m = { name = "Markdown/Misc" },
        o = { name = "open/obsidian" },
        n = { name = "nvimtree/noice" },
        p = { name = "Misc" },
        q = { name = "quit" },
        f = { name = "find" },
        t = { name = "toggle" },
        v = { name = "vgit" },
        z = { name = "Trouble/Misc" },
        ["<tab>"] = { name = "tabs" },
      },
    }
    local keymaps_v = {
      ["<leader>"] = {
        h = { name = "gitsings" },
        j = { name = "AI" },
        l = { name = "LSP" },
        o = { name = "open" },
      },
    }
    wk.register(keymaps_n)
    wk.register(keymaps_v, { mode = "v" })
  end,
}
