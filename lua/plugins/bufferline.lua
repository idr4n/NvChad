return {
  "akinsho/bufferline.nvim",
  enabled = false,
  event = "BufReadPost",
  keys = {
    { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
    { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
    { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete buffers to the right" },
    { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete buffers to the left" },
    { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
    { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
  },
  opts = function()
    local bufferline = require "bufferline"
    return {
      highlights = {
        fill = { bg = { attribute = "bg", highlight = "StatusLine" } },
        background = { bg = { attribute = "bg", highlight = "StatusLine" } },
        close_button = { bg = { attribute = "bg", highlight = "StatusLine" } },
        trunc_marker = { bg = { attribute = "bg", highlight = "StatusLine" } },
        duplicate = { bg = { attribute = "bg", highlight = "StatusLine" } },
        close_button_selected = { fg = "#B55A67" },
        separator = { bg = { attribute = "bg", highlight = "StatusLine" } },
        modified = { fg = "#B55A67", bg = { attribute = "bg", highlight = "StatusLine" } },
        hint = { bg = { attribute = "bg", highlight = "StatusLine" } },
        hint_diagnostic = { bg = { attribute = "bg", highlight = "StatusLine" } },
        info = { bg = { attribute = "bg", highlight = "StatusLine" } },
        info_diagnostic = { bg = { attribute = "bg", highlight = "StatusLine" } },
        warning = { bg = { attribute = "bg", highlight = "StatusLine" } },
        warning_diagnostic = { bg = { attribute = "bg", highlight = "StatusLine" } },
        error = { bg = { attribute = "bg", highlight = "StatusLine" } },
        error_diagnostic = { bg = { attribute = "bg", highlight = "StatusLine" } },
      },
      options = {
        buffer_close_icon = "",
        diagnostics = "nvim_lsp",
        always_show_bufferline = true,
        indicator = {
          -- icon = "▎", -- this should be omitted if indicator style is not 'icon'
          style = "none", -- "icon" | "underline" | "none",
        },
        diagnostics_indicator = function(_, _, diag)
          local ret = (diag.error and " " .. diag.error .. " " or "")
            .. (diag.warning and " " .. diag.warning .. " " or "")
            .. (diag.info and "󰋼 " .. diag.info .. " " or "")
            .. (diag.hint and "󰌵 " .. diag.hint or "")
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = "NvimTree",
            text = "NvimTree",
            -- highlight = "StatusLine",
            text_align = "center",
            separator = true,
          },
        },
        style_preset = {
          bufferline.style_preset.no_italic,
          bufferline.style_preset.no_bold,
        },
        -- separator_style = "slope", -- slant or slope is also nice
      },
    }
  end,
}
