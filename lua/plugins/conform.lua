return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format { async = true, lsp_fallback = true }
      end,
      desc = "File format",
    },
  },
  opts = {
    lsp_fallback = true,

    formatters_by_ft = {
      lua = { "stylua" },

      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      css = { "prettier" },
      html = { "prettier" },

      sh = { "shfmt" },
      go = { "goimports", "gofumpt" },
    },

    -- adding same formatter for multiple filetypes can look too much work for some
    -- instead of the above code you could just use a loop! the config is just a table after all!

    format_on_save = {
      -- These options will be passed to conform.format()
      timeout_ms = 500,
      lsp_fallback = true,
    },
  },
}
