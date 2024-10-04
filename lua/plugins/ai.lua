return {
  {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
    keys = {
      { "<leader>jt", "<cmd>CodeCompanionToggle<cr>", mode = { "n", "v" }, desc = "CodeCompanion Toggle" },
      { "<leader>jc", "<cmd>CodeCompanionChat<cr>", mode = { "n", "v" }, desc = "CodeCompanion Chat" },
      { "<leader>jC", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "CodeCompanion Actions" },
      { "<leader>ja", "<cmd>CodeCompanionAdd<cr>", mode = { "v" }, desc = "CodeCompanion Add Selection" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      strategies = {
        chat = { adapter = "anthropic" },
        inline = { adapter = "anthropic" },
      },
    },
  },

  {
    "Aaronik/GPTModels.nvim",
    cmd = { "GPTModelsCode" },
    keys = {
      { "<leader>jg", ":GPTModelsCode<cr>", mode = { "n", "v" }, desc = "GPTModelsCode" },
      { "<leader>jG", ":GPTModelsChat<cr>", mode = { "n", "v" }, desc = "GPTModelsChat" },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    keys = {
      {
        "<leader>cP",
        function()
          vim.cmd "Copilot toggle"
        end,
        desc = "Copilot Toggle",
      },
    },
    opts = {
      panel = {
        enabled = true,
        auto_refresh = true,
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<C-c>",
          accept_word = false,
          accept_line = false,
          next = "<C-n>",
          prev = "<C-p>",
          dismiss = "<C-]>",
        },
      },
    },
  },
}
