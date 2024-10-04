return {
  "lukas-reineke/indent-blankline.nvim",
  opts = {
    exclude = {
      filetypes = {
        "",
        "alpha",
        "dashboard",
        "NvimTree",
        "help",
        "markdown",
        "dirvish",
        "nnn",
        "packer",
        "toggleterm",
        "lsp-installer",
        "Outline",
      },
    },
  },
  config = function(_, opts)
    dofile(vim.g.base46_cache .. "blankline")
    local ut = require "utils"
    local hl_bg = ut.lighten(string.format("#%06x", vim.api.nvim_get_hl(0, { name = "Normal" }).bg), 0.9)

    local hooks = require "ibl.hooks"
    hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
    opts.scope.show_end = false
    require("ibl").setup(opts)

    local hl_group = "@ibl.scope.underline.1"
    vim.api.nvim_set_hl(0, hl_group, { bg = hl_bg })
  end,
}
