return {
  opts = {
    on_attach = function(bufnr)
      local api = require "nvim-tree.api"

      local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      -- default mappings
      api.config.mappings.default_on_attach(bufnr)

      -- remove a default
      vim.keymap.del("n", "<C-t>", { buffer = bufnr })

      vim.keymap.set("n", "l", api.node.open.edit, opts "Edit Or Open")
      vim.keymap.set("n", "h", function()
        local node = api.tree.get_node_under_cursor()
        if node.nodes ~= nil then
          api.node.navigate.parent_close()
        else
          api.node.navigate.parent()
        end
      end, opts "Go to parent or close")

      vim.keymap.set("n", "<CR>", function()
        api.node.open.edit()
        api.tree.close_in_this_tab()
      end, opts "Open and close tree")
    end,

    hijack_netrw = true,
    disable_netrw = true,

    -- view = {
    --   width = 32,
    -- },

    view = {
      adaptive_size = false,
      -- side = "left",
      side = "right",
      width = 32,
      preserve_window_proportions = true,
      -- signcolumn = "no",
      float = {
        enable = true,
        quit_on_focus_loss = false,
        open_win_config = function()
          local screen_w = vim.opt.columns:get()
          local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
          -- local window_w = screen_w * 0.3
          local window_w = math.min(math.floor(screen_w * 0.28), 38)
          local window_h = screen_h * 0.925
          local window_w_int = math.floor(window_w)
          local window_h_int = math.floor(window_h)

          -- adjust for the offset
          local col_right_aligned = screen_w - window_w_int - 3
          local row_offset = 1

          return {
            border = "rounded",
            relative = "editor",
            row = row_offset,
            col = col_right_aligned,
            width = window_w_int,
            height = window_h_int,
          }
        end,
      },
    },

    git = {
      enable = true,
    },

    renderer = {
      highlight_git = true,
      icons = {
        show = {
          git = true,
        },
      },
    },
  },
}
