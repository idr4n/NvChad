return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "nvim-telescope/telescope-ui-select.nvim" },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  keys = function()
    _G.dropdown_theme = function(opts)
      opts = vim.tbl_deep_extend("force", {
        disable_devicons = false,
        previewer = false,
        layout_config = {
          width = function(_, max_columns, _)
            return math.min(math.floor(max_columns * 0.82), 120)
          end,
          height = function(_, _, max_lines)
            return math.min(math.floor(max_lines * 0.8), 20)
          end,
        },
      }, opts or {})
      return require("telescope.themes").get_dropdown(opts)
    end

    return {
      {
        "<C-Space>",
        function()
          -- require("telescope.builtin").find_files()
          require("telescope.builtin").find_files(dropdown_theme())
        end,
        noremap = true,
        silent = true,
        desc = "Telescope-find_files",
      },
      {
        "<C-P>",
        "<cmd>lua require('telescope.builtin').find_files({ no_ignore = true })<CR>",
        desc = "Find Files (root dir)",
      },
      { "<leader>fk", "<cmd> Telescope keymaps <CR>", desc = "Key Maps" },
      {
        "gd",
        function()
          require("telescope.builtin").lsp_definitions(require("telescope.themes").get_ivy { initial_mode = "normal" })
        end,
        desc = "Go to LSP definition",
      },
      {
        "<leader>,",
        function()
          require("telescope.builtin").buffers(require("telescope.themes").get_dropdown {
            initial_mode = "normal",
            sort_lastused = true,
            ignore_current_buffer = false,
            previewer = false,
          })
        end,
        desc = "Switch buffer",
      },
      -- {
      --   "gr",
      --   function()
      --     require("telescope.builtin").lsp_references { initial_mode = "normal" }
      --   end,
      --   desc = "LSP Refences",
      -- },
      {
        "<leader>r",
        function()
          local text = vim.getVisualSelection()
          require("telescope.builtin").live_grep { default_text = text }
        end,
        mode = { "n", "v" },
        desc = "Live grep",
      },
      {
        "<leader>fh",
        function()
          local text = vim.getVisualSelection()
          require("telescope.builtin").help_tags { default_text = text }
        end,
        mode = { "v" },
        desc = "Help pages",
      },
      {
        "gs",
        "<cmd>Telescope lsp_document_symbols<cr>",
        noremap = true,
        silent = true,
        desc = "LSP document symbols",
      },
      {
        "<leader>ls",
        "<cmd>Telescope lsp_document_symbols<cr>",
        noremap = true,
        silent = true,
        desc = "LSP document symbols",
      },
      {
        "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
        noremap = true,
        silent = true,
        desc = "LSP workspace symbols",
      },
      { "<leader>ot", "<cmd>Telescope resume<cr>", desc = "Telescope Resume" },
    }
  end,
  opts = function()
    local actions = require "telescope.actions"
    local conf = require "nvchad.configs.telescope"
    conf.defaults.mappings.i = {
      ["jk"] = { "<esc>", type = "command" },
      ["<C-n>"] = require("telescope.actions").cycle_history_next,
      ["<C-p>"] = require("telescope.actions").cycle_history_prev,
      ["<C-j>"] = actions.move_selection_next,
      ["<C-k>"] = actions.move_selection_previous,
      ["<C-c>"] = require("telescope.actions").close,
      ["<C-g>"] = {
        actions.close,
        type = "action",
        opts = { nowait = true, silent = true },
      },
      ["<C-l>"] = require("telescope.actions.layout").toggle_preview,
    }
    conf.defaults.mappings.n = {
      ["<esc>"] = actions.close,
      ["<C-c>"] = actions.close,
      ["<C-g>"] = actions.close,
      ["<C-l>"] = require("telescope.actions.layout").toggle_preview,
      ["l"] = actions.select_default,
      ["s"] = actions.close,
    }
    conf.extensions_list = { "themes", "terms", "fzf" }

    conf.pickers = {
      -- Default configuration for builtin pickers goes here:
      find_files = {
        find_command = {
          "rg",
          "--files",
          "--hidden",
          "--follow",
          "--no-ignore",
          "-g",
          "!{node_modules,.git,**/_build,deps,.elixir_ls,**/target,**/assets/node_modules,**/assets/vendor,**/.next,**/.vercel,**/build,**/out}",
        },
      },
      live_grep = {
        additional_args = function()
          return {
            "--hidden",
            "--follow",
            "--no-ignore",
            "-g",
            "!{node_modules,.git,**/_build,deps,.elixir_ls,**/target,**/assets/node_modules,**/assets/vendor,**/.next,**/.vercel,**/build,**/out}",
          }
        end,
      },
    }

    conf.extensions = {
      ["ui-select"] = {
        require("telescope.themes").get_dropdown {
          layout_config = {
            height = function(_, _, max_lines)
              return math.min(max_lines, 10)
            end,
          },
        },
        -- require("telescope.themes").get_cursor(),
      },
    }

    table.insert(conf.extensions_list, "ui-select")

    return conf
  end,
}
