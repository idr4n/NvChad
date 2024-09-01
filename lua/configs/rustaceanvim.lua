return {
  opts = {
    tools = {
      float_win_config = {
        border = "rounded",
      },
    },
    server = {
      on_attach = function(client, bufnr)
        require("configs.lspconfig").on_attach(client, bufnr)
        vim.keymap.set("n", "<leader>ca", function()
          vim.cmd.RustLsp "codeAction"
        end, { desc = "Code Action (Rust)", buffer = bufnr })
        vim.keymap.set("n", "<leader>dR", function()
          vim.cmd.RustLsp "debuggables"
        end, { desc = "Rust Debuggables", buffer = bufnr })
      end,
      default_settings = {
        -- rust-analyzer language server configuration
        ["rust-analyzer"] = {
          cargo = {
            allFeatures = true,
            loadOutDirsFromCheck = true,
            runBuildScripts = true,
          },
          -- Add clippy lints for Rust.
          checkOnSave = {
            allFeatures = true,
            command = "clippy",
            extraArgs = { "--no-deps" },
          },
          procMacro = {
            enable = true,
            ignored = {
              ["async-trait"] = { "async_trait" },
              ["napi-derive"] = { "napi" },
              ["async-recursion"] = { "async_recursion" },
            },
          },
        },
      },
    },
  },
}
