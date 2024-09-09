-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

local highlights = require "highlights"
local st = require "statusline"

M.base46 = {
  theme = "nord",
  theme_toggle = { "chadracula", "nord" },

  hl_add = highlights.add,
  hl_override = highlights.override,
}

M.ui = {
  lsp = {
    signature = true,
    semantic_tokens = true,
  },

  telescope = { style = "bordered" },

  statusline = {
    theme = "vscode",
    -- theme = "default",

    -- stylua: ignore
    -- order = { "mode", "filetype", "hl_status", "file", "diagnostics", "git", "%=", "search_count", "lsp_msg", "%=", "hl_stealth", "charcode", "LSP", "position", "cwd" }, -- custom status
    order = { "mode", "filetype", "hl_stealth", "file", "lsp_diagnostics", "%=", "search_count", "lsp_msg", "%=", "hl_stealth", "word_count", "charcode", "LSP", "position", "git", "git_hunks", "cwd" }, -- custom status

    modules = {
      -- mode = st.mode,
      mode = st.color_mode,
      filetype = st.filetype,
      lsp_diagnostics = st.LSP_Diagnostics,
      cwd = st.cwd,
      hl_status = function()
        return "%#StatusLine#"
      end,
      hl_stealth = st.hl_stealth,
      file = function()
        return st.fileblock()
        -- return _G.show_more_info and st.fileblock() or ""
      end,
      search_count = st.search_count,
      charcode = function()
        return _G.show_more_info and st.charcode() or ""
      end,
      position = function()
        return _G.show_more_info and st.position() or ""
      end,
      LSP = function()
        return _G.show_more_info and st.lsp_running() or ""
      end,
      git = function()
        return _G.show_more_info and st.git() or ""
      end,
      word_count = st.get_words,
      git_hunks = function()
        return not _G.show_more_info and st.git_hunks() or ""
      end,
    },
  },

  -- lazyload it when there are 1+ buffers
  tabufline = {
    enabled = true,
    lazyload = false,
    order = { "buffers", "tabs", "btns" },
  },

  mason = {
    cmd = true,
    pkgs = {
      -- lua stuff
      "lua-language-server",
      "stylua",

      -- web dev stuff
      "css-lsp",
      "html-lsp",
      "tailwindcss-language-server",
      "typescript-language-server",
      "deno",
      "prettier",

      -- c/cpp stuff
      "clangd",
      "clang-format",

      -- python
      "pyright",
      "ruff-lsp",
    },
  },
}

return M
