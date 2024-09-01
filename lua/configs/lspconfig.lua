-- local on_attach = require("plugins.configs.lspconfig").on_attach
local lsp_conf = require "nvchad.configs.lspconfig"

local M = {}

local map = vim.keymap.set
local conf = require("nvconfig").ui.lsp

-- local function on_attach(client, bufnr)
function M.on_attach(client, bufnr)
  local function opts(desc)
    return { buffer = bufnr, desc = desc }
  end

  map("n", "gD", vim.lsp.buf.declaration, opts "Lsp Go to declaration")
  -- map("n", "gd", vim.lsp.buf.definition, opts "Lsp Go to definition")
  map("n", "K", vim.lsp.buf.hover, opts "Lsp hover information")
  -- map("n", "gi", vim.lsp.buf.implementation, opts "Lsp Go to implementation")
  map("n", "<leader>lh", vim.lsp.buf.signature_help, opts "Lsp Show signature help")
  map("n", "<leader>lA", vim.lsp.buf.add_workspace_folder, opts "Lsp Add workspace folder")
  map("n", "<leader>lR", vim.lsp.buf.remove_workspace_folder, opts "Lsp Remove workspace folder")

  map("n", "<leader>ll", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts "Lsp List workspace folders")

  map("n", "<leader>D", vim.lsp.buf.type_definition, opts "Lsp Go to type definition")

  map("n", "<leader>lr", function()
    require "nvchad.lsp.renamer"()
  end, opts "Lsp NvRenamer")
  map("n", "<leader>cR", function()
    require "nvchad.lsp.renamer"()
  end, opts "Lsp NvRenamer")

  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts "Lsp Code action")
  map({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, opts "Lsp Code action")
  -- map("n", "gr", vim.lsp.buf.references, opts "Lsp Show references")

  -- setup signature popup
  if conf.signature and client.server_capabilities.signatureHelpProvider then
    require("nvchad.lsp.signature").setup(client, bufnr)
  end

  -- require("nvchad.configs.lspconfig").on_attach(client, bufnr)
  local clientsNoHover = { "tailwindcss", "cssmodules_ls", "ruff_lsp" }
  for _, v in ipairs(clientsNoHover) do
    if client.name == v then
      client.server_capabilities.hoverProvider = false
    end
  end

  if vim.fn.has "nvim-0.10.0" == 1 then
    -- inlay_hints
    if vim.lsp.inlay_hint and client.supports_method "textDocument/inlayHint" then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      vim.keymap.set("n", "<leader>tH", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }, { bufnr = bufnr })
      end, { buffer = bufnr, desc = "Toggle inlay hints" })
    end
  end
end

local lspconfig = require "lspconfig"

-- if you just want default config for the servers then put them in a table
local servers = {
  "bashls",
  "html",
  "cssls",
  "tsserver",
  "tailwindcss",
  "clangd",
  "pyright",
  "ruff_lsp",
  "typst_lsp",
  "texlab",
  "gopls",
  -- "rust_analyzer", -- configured by rustaceanvim instead
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    -- on_attach = on_attach,
    on_attach = M.on_attach,
    capabilities = lsp_conf.capabilities,
  }
end

lspconfig.lua_ls.setup {
  -- on_attach = on_attach,
  on_attach = M.on_attach,
  capabilities = lsp_conf.capabilities,
  on_init = lsp_conf.on_init,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim", "hs" },
      },
      workspace = {
        library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
          [vim.fn.stdpath "config" .. "/lua"] = true,
          [vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types"] = true,
          [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
    },
  },
}

return M
