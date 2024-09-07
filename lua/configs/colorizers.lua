M = {}

M.colored_fts = {
  "cfg",
  "css",
  "html",
  "conf",
  "lua",
  "scss",
  "toml",
  "markdown",
}

M.colorizer_opts = {
  filetypes = { "*", "!lazy" },
  buftype = { "*", "!prompt", "!nofile" },
  user_default_options = {
    RGB = true, -- #RGB hex codes
    RRGGBB = true, -- #RRGGBB hex codes
    names = false, -- "Name" codes like Blue
    RRGGBBAA = true, -- #RRGGBBAA hex codes
    AARRGGBB = true, -- 0xAARRGGBB hex codes
    rgb_fn = true, -- CSS rgb() and rgba() functions
    hsl_fn = true, -- CSS hsl() and hsla() functions
    css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
    css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
    tailwind = "lsp",
    mode = "background", -- Set the display mode.
    virtualtext = "■",
  },
}

M.ccc_opts = function()
  local ccc = require "ccc"

  -- Use uppercase for hex codes.
  ccc.output.hex.setup { uppercase = true }
  ccc.output.hex_short.setup { uppercase = true }

  return {
    alpha_show = "hide",
    highlighter = {
      auto_enable = false,
      filetypes = M.colored_fts,
    },
  }
end

return M
