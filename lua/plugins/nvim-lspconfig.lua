return {
  "neovim/nvim-lspconfig",
  dependencies = {
    {
      "linrongbin16/lsp-progress.nvim",
      opts = {
        max_size = 50,
        spinner = { "", "󰪞", "󰪟", "󰪠", "󰪢", "󰪣", "󰪤", "󰪥" },
        -- client_format = function(client_name, spinner, series_messages)
        client_format = function(_, spinner, series_messages)
          return #series_messages > 0
              -- and (spinner .. " [" .. client_name .. "] " .. table.concat(series_messages, ", "))
              and (spinner .. " (LSP) " .. table.concat(series_messages, ", "))
            or nil
        end,
        format = function(client_messages)
          if #client_messages > 0 then
            return table.concat(client_messages, " ")
          end
          return ""
        end,
      },
    },
  },
  config = function()
    require("nvchad.configs.lspconfig").defaults()
    require "configs.lspconfig"
  end,
}
