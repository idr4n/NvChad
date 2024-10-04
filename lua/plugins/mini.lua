return {
  {
    "echasnovski/mini.surround",
    keys = function(_, keys)
      -- Populate the keys based on the user's options
      local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
      local opts = require("lazy.core.plugin").values(plugin, "opts", false)
      local mappings = {
        { opts.mappings.add, desc = "Add surrounding", mode = { "n", "v" } },
        { opts.mappings.delete, desc = "Delete surrounding" },
        { opts.mappings.find, desc = "Find right surrounding" },
        { opts.mappings.find_left, desc = "Find left surrounding" },
        { opts.mappings.highlight, desc = "Highlight surrounding" },
        { opts.mappings.replace, desc = "Replace surrounding" },
        { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
      }
      mappings = vim.tbl_filter(function(m)
        return m[1] and #m[1] > 0
      end, mappings)
      return vim.list_extend(mappings, keys)
    end,
    opts = {
      mappings = {
        add = "S", -- Add surrounding
        delete = "ds", -- Delete surrounding
        replace = "cs", -- Replace surrounding
        find = "fs", -- Find surrounding (to the right)
        find_left = "Fs", -- Find surrounding (to the left)
        highlight = "", -- Highlight surrounding
        update_n_lines = "", -- Update `n_lines`
      },
    },
  },

  {
    "echasnovski/mini.files",
    keys = {
      {
        "<C-Q>",
        function()
          local bufname = vim.api.nvim_buf_get_name(0)
          local path = vim.fn.fnamemodify(bufname, ":p")
          if path and vim.uv.fs_stat(path) then
            local MiniFiles = require "mini.files"
            if not MiniFiles.close() then
              MiniFiles.open(bufname, false)
            end
          end
        end,
        silent = true,
        desc = "Mini Files",
      },
    },
    -- init = function()
    --   if vim.fn.argc(-1) == 1 then
    --     local stat = vim.loop.fs_stat(vim.fn.argv(0))
    --     if stat and stat.type == "directory" then
    --       require("mini.files").open()
    --     end
    --   end
    -- end,
    opts = function()
      local copy_path = function()
        local cur_entry_path = require("mini.files").get_fs_entry().path
        vim.fn.setreg("+", cur_entry_path)
        print "Path copied to clipboard!"
      end
      vim.api.nvim_create_autocmd("User", {
        group = vim.api.nvim_create_augroup("idr4n/mini-files", { clear = true }),
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          vim.keymap.set("n", "Y", copy_path, { buffer = args.data.buf_id })
        end,
      })
      return {
        mappings = {
          show_help = "?",
          go_in_plus = "l",
          go_out_plus = "<tab>",
        },
        windows = { width_nofocus = 25 },
      }
    end,
  },
}
