return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "css",
        "elixir",
        "go",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "regex",
        "scss",
        "svelte",
        "swift",
        "tsx",
        "typescript",
        "typst",
        "vim",
        "vimdoc",
        "zig",
      },
      ignore_install = { "help" },
      indent = {
        enable = true,
        -- disable = {
        --   "python"
        -- },
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "LspAttach",
    opts = {
      textobjects = {
        select = {
          enable = true,
          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@conditional.outer",
            ["ic"] = "@conditional.inner",
            ["al"] = "@loop.outer",
            ["il"] = "@loop.inner",
          },
        },
        lsp_interop = {
          enable = true,
          border = "rounded",
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
