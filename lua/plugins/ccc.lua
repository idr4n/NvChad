local colored_fts = {
  "cfg",
  "css",
  "html",
  "conf",
  "lua",
  "scss",
  "toml",
  "markdown",
}

return {
  "uga-rosa/ccc.nvim",
  -- enabled = false,
  -- ft = require("configs.colorizers").colored_fts,
  cmd = { "CccPick", "CccHighlighterToggle" },
  keys = {
    -- { ",c", "<cmd>CccHighlighterToggle<cr>", silent = true, desc = "Toggle colorizer" },
    { ",p", "<cmd>CccPick<cr>", silent = true, desc = "Pick color" },
  },
  opts = function()
    local ccc = require "ccc"

    -- Use uppercase for hex codes.
    ccc.output.hex.setup { uppercase = true }
    ccc.output.hex_short.setup { uppercase = true }

    return {
      alpha_show = "hide",
      highlighter = {
        auto_enable = false,
        filetypes = colored_fts,
      },
    }
  end,
}
