return {
  {
    "williamboman/mason.nvim",
    keys = { { "<leader>om", "<cmd>Mason<cr> ", desc = "Open Mason" } },
  },

  {
    "mattn/emmet-vim",
    -- event = "InsertEnter",
    ft = { "htlml", "css", "scss", "javascript", "javascriptreact", "typescripts", "typescriptreact" },
    init = function()
      vim.g.user_emmet_leader_key = "<C-W>"
    end,
  },

  {
    "michaeljsmith/vim-indent-object",
    event = { "BufReadPost", "BufNewFile" },
  },

  {
    "junegunn/vim-easy-align",
    keys = {
      { "ga", "<Plug>(EasyAlign)", mode = "x", desc = "EasyAlign" },
    },
  },

  {
    "dhruvasagar/vim-table-mode",
    ft = { "markdown" },
    init = function()
      vim.g.table_mode_disable_mappings = 1
      vim.g.table_mode_disable_tableize_mappings = 1
    end,
  },

  {
    "lervag/vimtex",
    ft = { "tex" },
    config = function()
      vim.g.vimtex_view_method = vim.fn.has "mac" == 1 and "skim" or "zathura"
      vim.g.vimtex_compiler_silent = 1
      vim.g.vimtex_syntax_enabled = 0
    end,
  },

  -- Split/join blocks of code.
  {
    "Wansmer/treesj",
    dependencies = "nvim-treesitter",
    keys = {
      { "<leader>cj", "<cmd>TSJToggle<cr>", desc = "Join/split code block" },
    },
    opts = {
      use_default_keymaps = false,
      max_join_length = 999,
    },
  },
}
