local M = {}

local highlights = require "highlights"
local st = require "statusline"

M.ui = {
  theme = "chadracula",
  theme_toggle = { "chadracula", "chadracula" },

  hl_add = highlights.add,
  hl_override = highlights.override,

  lsp = {
    signature = true,
    semantic_tokens = true,
  },

  statusline = {
    theme = "vscode",
    -- theme = "default",

    -- stylua: ignore
    -- order = { "mode", "filetype", "hl_status", "file", "diagnostics", "git", "%=", "search_count", "lsp_msg", "%=", "hl_stealth", "charcode", "LSP", "position", "cwd" }, -- custom status
    order = { "mode", "filetype", "hl_status", "file", "diagnostics", "%=", "search_count", "lsp_msg", "%=", "word_count", "hl_stealth", "charcode", "LSP", "position", "git", "cwd" }, -- custom status

    modules = {
      -- mode = st.mode,
      mode = st.color_mode,
      filetype = st.filetype,
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
      -- git = function()
      --   return _G.show_more_info and st.git() or ""
      -- end,
      git = st.git,
      word_count = st.get_words,
      -- hunks = function()
      --   return not _G.show_more_info and st.git_hunks() or ""
      -- end,
    },
  },

  -- lazyload it when there are 1+ buffers
  tabufline = {
    enabled = true,
    lazyload = false,
    order = { "buffers", "tabs", "btns" },
  },
}

return M
