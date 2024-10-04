return {
  "L3MON4D3/LuaSnip",
  keys = require("configs.luasnip").keys,
  config = function(_, opts)
    require("luasnip").config.set_config(opts)
    require "nvchad.configs.luasnip"
    require("configs.luasnip").config()
  end,
}
