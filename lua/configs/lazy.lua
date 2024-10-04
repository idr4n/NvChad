return {
  defaults = { lazy = true },
  install = { colorscheme = { "nvchad" } },

  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = false, -- notify on update
  },

  ui = {
    icons = {
      ft = "",
      lazy = "󰂠 ",
      loaded = "",
      not_loaded = "",
    },
  },

  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
}
