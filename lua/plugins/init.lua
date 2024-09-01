return {
  -- Core
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "css",
        "elixir",
        "go",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "regex",
        "scss",
        "svelte",
        "swift",
        "tsx",
        "typescript",
        "typst",
        "vim",
        "vimdoc",
      },
      ignore_install = { "help" },
      indent = {
        enable = true,
        -- disable = {
        --   "python"
        -- },
      },
    },
  },

  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "BufReadPost" },
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      { "js-everts/cmp-tailwind-colors", config = true },
    },
    opts = require("configs.cmp").opts,
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- preset = "modern",
      -- preset = "helix",
      notify = false,
      icons = {
        rules = false,
        separator = "",
      },
      win = {
        -- no_overlap = false,
        -- width = { max = 0.28 },
        height = { min = 4, max = 20 },
      },
    },
    config = function(_, opts)
      -- default config function's stuff
      dofile(vim.g.base46_cache .. "whichkey")
      require("which-key").setup(opts)

      local wk = require "which-key"
      local keymaps_n = {
        ["<leader>"] = {
          b = { name = "buffer" },
          c = { name = "code" },
          g = { name = "git/glance" },
          h = { name = "gitsings" },
          j = { name = "AI" },
          l = { name = "LSP" },
          o = { name = "open/obsidian" },
          n = { name = "nvimtree/noice" },
          q = { name = "quit" },
          f = { name = "find" },
          t = { name = "toggle" },
          v = { name = "vgit" },
          z = { name = "misc" },
          ["<tab>"] = { name = "tabs" },
        },
      }
      local keymaps_v = {
        ["<leader>"] = {
          h = { name = "gitsings" },
          j = { name = "AI" },
          l = { name = "LSP" },
          o = { name = "open" },
        },
      }
      wk.register(keymaps_n)
      wk.register(keymaps_v, { mode = "v" })
    end,
  },

  -- Editor
  {
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
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "blankline")
      local ut = require "utils"
      local hl_bg = ut.lighten(string.format("#%06x", vim.api.nvim_get_hl(0, { name = "Normal" }).bg), 0.9)

      local hooks = require "ibl.hooks"
      hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
      opts.scope.show_end = false
      require("ibl").setup(opts)

      local hl_group = "@ibl.scope.underline.1"
      vim.api.nvim_set_hl(0, hl_group, { bg = hl_bg })
      -- vim.api.nvim_set_hl(0, hl_group, { standout = true, underline = false })
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    opts = require "configs.gitsigns",
  },

  {
    "L3MON4D3/LuaSnip",
    keys = require("configs.luasnip").keys,
    config = function(_, opts)
      require("luasnip").config.set_config(opts)
      require "nvchad.configs.luasnip"
      require("configs.luasnip").config()
    end,
  },

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
    "windwp/nvim-autopairs",
    -- enabled = false,
    opts = {
      fast_wrap = {},
      disable_filetype = { "TelescopePrompt", "vim" },
    },
    config = function(_, opts)
      local npairs = require "nvim-autopairs"
      npairs.setup(opts)

      -- setup cmp for autopairs
      local cmp_autopairs = require "nvim-autopairs.completion.cmp"
      require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())

      local Rule = require "nvim-autopairs.rule"

      local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }
      npairs.add_rules {
        Rule(" ", " "):with_pair(function(opts)
          local pair = opts.line:sub(opts.col - 1, opts.col)
          return vim.tbl_contains({
            brackets[1][1] .. brackets[1][2],
            brackets[2][1] .. brackets[2][2],
            brackets[3][1] .. brackets[3][2],
          }, pair)
        end),
      }
      for _, bracket in pairs(brackets) do
        npairs.add_rules {
          Rule(bracket[1] .. " ", " " .. bracket[2])
            :with_pair(function()
              return false
            end)
            :with_move(function(opts)
              return opts.prev_char:match(".%" .. bracket[2]) ~= nil
            end)
            :use_key(bracket[2]),
        }
      end
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    keys = {
      { "<leader>na", ":NvimTreeCollapse<cr>", silent = true, desc = "NvimTree Collapse All" },
      {
        "<leader>nc",
        function()
          vim.cmd "NvimTreeCollapse"
          require("nvim-tree.api").tree.find_file()
        end,
        silent = true,
        desc = "NvimTree Collapse",
      },
      {
        "<leader><Space>",
        function()
          require("nvim-tree.api").tree.close()
          require("nvim-tree.api").tree.find_file { open = true, current_window = true }
        end,
        silent = true,
        desc = "NvimTree Open",
      },
    },
    init = function()
      if vim.fn.argc(-1) == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require "nvim-tree"
        end
      end
    end,
    opts = require("configs.nvimtree").opts,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "nvimtree")
      require("nvim-tree").setup(opts)
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-telescope/telescope-ui-select.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = require("configs.telescope").keys,
    opts = require("configs.telescope").opts,
  },

  -- LSP
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    config = function()
      require "configs.conform"
    end,
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },

  {
    "williamboman/mason.nvim",
    keys = { { "<leader>om", "<cmd>Mason<cr> ", desc = "Open Mason" } },
    opts = {
      ensure_installed = {
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
  },

  -- Misc
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    keys = {
      { "<leader>od", "<cmd>Dashboard<cr>", desc = "Open Dashboard" },
    },
    opts = require("configs.dashboard").opts,
  },

  {
    "Shatur/neovim-session-manager",
    event = "BufReadPre",
    dependencies = { "nvim-lua/plenary.nvim" },
    -- stylua: ignore
    keys = {
      { "<leader>qs", function() require("session_manager").load_current_dir_session() end, desc = "Restore Current Dir Session" },
      { "<leader>ql", function() require("session_manager").load_last_session() end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("session_manager").delete_current_dir_session() end, desc = "Delete Current Dir Session" },
    },
    config = function()
      require("session_manager").setup {}
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "LspAttach",
    opts = {
      textobjects = {
        select = {
          enable = true,
          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@conditional.outer",
            ["ic"] = "@conditional.inner",
            ["al"] = "@loop.outer",
            ["il"] = "@loop.inner",
          },
        },
        lsp_interop = {
          enable = true,
          border = "rounded",
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  {
    "dnlhc/glance.nvim",
    keys = {
      { "<leader>gg", "<CMD>Glance definitions<CR>", desc = "Glance definitions" },
      { "gr", "<CMD>Glance references<CR>", desc = "LSP references (Glance)" },
      { "<leader>lr", "<CMD>Glance references<CR>", desc = "LSP references" },
      { "<leader>gd", "<CMD>Glance type_definitions<CR>", desc = "Glance type definitions" },
      { "<leader>gm", "<CMD>Glance implementations<CR>", desc = "Glance implementations" },
    },
    opts = {
      border = { enable = true, top_char = "─", bottom_char = "─" },
    },
  },

  {
    "tanvirtin/vgit.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      {
        "<leader>vp",
        function()
          require("vgit").buffer_hunk_preview()
        end,
        desc = "Hunk preview (vgit)",
      },
      {
        "<leader>vd",
        function()
          require("vgit").buffer_diff_preview()
        end,
        desc = "Buffer diff preview (vgit)",
      },
    },
    opts = {
      keymaps = {
        ["n <C-k>"] = function()
          require("vgit").hunk_up()
        end,
        ["n <C-j>"] = function()
          require("vgit").hunk_down()
        end,
        ["n [c"] = function()
          require("vgit").hunk_up()
        end,
        ["n ]c"] = function()
          require("vgit").hunk_down()
        end,
      },
      settings = {
        live_blame = { enabled = false },
        live_gutter = { enabled = false },
        authorship_code_lens = { enabled = false },
        scene = {
          diff_preference = "split",
          keymaps = {
            quit = "q",
          },
        },
        signs = {
          definitions = {
            GitSignsAdd = { text = "│" },
            GitSignsDelete = { text = "󰍵" },
            GitSignsChange = { text = "│" },
          },
        },
      },
    },
  },

  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,
    keys = {
      { "<leader>vo", ":DiffviewOpen<cr>", desc = "Diffview Project Open" },
      { "<leader>vh", ":DiffviewFileHistory %<cr>", desc = "Diffview File History" },
    },
  },

  {
    "TimUntersberger/neogit",
    dependencies = "nvim-lua/plenary.nvim",
    keys = {
      { "<leader>gn", ":Neogit<cr>", noremap = true, silent = true, desc = "Neogit" },
    },
    opts = {
      disable_signs = false,
      signs = {
        -- { CLOSED, OPENED }
        section = { "", "" },
        item = { "", "" },
      },
      integrations = { diffview = true },
    },
  },

  {
    "mattn/emmet-vim",
    -- event = "InsertEnter",
    ft = { "htlml", "css", "scss", "javascript", "javascriptreact", "typescripts", "typescriptreact" },
    init = function()
      vim.g.user_emmet_leader_key = "<C-W>"
    end,
  },

  {
    "folke/zen-mode.nvim",
    cmd = { "ZenMode" },
    opts = {
      window = {
        width = 85,
        height = 0.95,
        backdrop = 1,
        options = {
          number = false,
          relativenumber = false,
          signcolumn = "no",
          cursorcolumn = false,
        },
      },
      plugins = {
        -- gitsigns = { enabled = false },
        options = {
          laststatus = 3,
        },
      },
    },
    keys = {
      { "<leader>zz", ":ZenMode<cr>", noremap = true, silent = true, desc = "Zen mode" },
    },
  },

  {
    "ThePrimeagen/harpoon",
    keys = {
      { "<leader>hh", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", desc = "Toggle Harpoon" },
      { "<leader>ha", "<cmd>lua require('harpoon.mark').add_file()<cr>", desc = "Add Harpoon" },
      { "<M-u>", "<cmd>lua require('harpoon.ui').nav_file(1)<cr>" },
      { "<M-i>", "<cmd>lua require('harpoon.ui').nav_file(2)<cr>" },
      { "<M-o>", "<cmd>lua require('harpoon.ui').nav_file(3)<cr>" },
      { "<M-p>", "<cmd>lua require('harpoon.ui').nav_file(4)<cr>" },
      { "<M-[>", "<cmd>lua require('harpoon.ui').nav_file(5)<cr>" },
      { "<M-]>", "<cmd>lua require('harpoon.ui').nav_file(6)<cr>" },
    },
    dependencies = "nvim-lua/plenary.nvim",
  },

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    config = function()
      -- vim.g.mkdp_browser = "Vivaldi"
      vim.g.mkdp_highlight_css = vim.fn.expand "~/md-preview.css"
    end,
  },

  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    ft = "markdown",
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    -- stylua: ignore
    -- event = {
    --   "BufReadPre " .. vim.fn.expand("~") .. "/Sync/Notes-Database/**.md",
    --   "BufNewFile " .. vim.fn.expand("~") .. "/Sync/Notes-Database/**.md",
    --   "BufReadPre " .. vim.fn.expand("~") .. "/Sync/Notes-tdo/**.md",
    --   "BufNewFile " .. vim.fn.expand("~") .. "/Sync/Notes-tdo/**.md",
    -- },
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>oo", "<cmd>ObsidianQuickSwitch<CR>", desc = "[O]pen note" },
      { "<leader>oa", "<cmd>ObsidianNew<CR>", desc = "[A]dd note" },
      { "<leader>or", "<cmd>ObsidianRename<CR>", desc = "[R]ename note", buffer = true, ft = "markdown" },
      { "<leader>os", "<cmd>ObsidianSearch<CR>", desc = "[S]earch text in notes" },
      { "<leader>oi", "<cmd>ObsidianPasteImg<CR>", desc = "Add [i]mage", buffer = true, ft = "markdown" },
      { "<leader>oT", "<cmd>ObsidianTags<CR>", desc = "Search notes in [t]ag", buffer = true, ft = "markdown" },
      {
        "<leader>ox",
        ":ObsidianExtractNote<CR>",
        desc = "E[x]tract note from selection",
        mode = { "x" },
      },
      { "<leader>oL", "<cmd>ObsidianLinks<CR>", desc = "Show [l]inks", buffer = true, ft = "markdown" },
      { "<leader>ob", "<cmd>ObsidianBacklinks<CR>", desc = "Show [b]ack links", buffer = true, ft = "markdown" },
    },
    opts = require("configs.obsidian").opts,
  },

  {
    "abecodes/tabout.nvim",
    -- enabled = false, -- not needed if using ultimate-autopair
    event = "InsertEnter",
    dependencies = { "nvim-treesitter" },
    opts = {
      tabkey = [[<C-\>]], -- key to trigger tabout, set to an empty string to disable
      backwards_tabkey = [[<C-S-\>]], -- key to trigger backwards tabout, set to an empty string to disable
      act_as_tab = false, -- shift content if tab out is not possible
      act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
      enable_backwards = true, -- well ...
      completion = true, -- if the tabkey is used in a completion pum
      tabouts = {
        { open = "'", close = "'" },
        { open = '"', close = '"' },
        { open = "`", close = "`" },
        { open = "(", close = ")" },
        { open = "[", close = "]" },
        { open = "{", close = "}" },
      },
      ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
      exclude = {}, -- tabout will ignore these filetypes
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

  {
    "folke/trouble.nvim",
    -- stylua: ignore
    keys = {
      --: v3
      -- { "gr", "<cmd>Trouble lsp_references toggle<cr>", silent = true, noremap = true, desc = "LSP references (Trouble)" },
      { "<leader>zr", "<cmd>Trouble lsp_references toggle<cr>", silent = true, noremap = true, desc = "LSP references (Trouble)" },
      { "<leader>zx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>zX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
      { "<leader>zs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
      { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions / references / ... (Trouble)", },
      { "<leader>zl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions / references / ... (Trouble)", },
      { "<leader>zL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
      { "<leader>zq", "<cmd>Trouble qflist toggle preview.type=float<cr>", desc = "Quickfix List (Trouble)" },
      { "]q", "<cmd>lua require('trouble').next()<cr>", silent = true, desc = "Trouble next", },
      { "[q", "<cmd>lua require('trouble').prev()<cr>", silent = true, desc = "Trouble previous", },
    },
    opts = {
      height = 15,
      --: v3
      focus = true,
      -- preview = { type = "float" },
    },
  },

  {
    "voldikss/vim-floaterm",
    -- stylua: ignore
    keys = {
      { ",l", ":FloatermNew --title=LF --titleposition=center lf<cr>", silent = true, desc = "Open LF" },
      { ",j", ":FloatermNew --title=Joshuto --titleposition=center joshuto<cr>", silent = true, desc = "Open Joshuto" },
      { ",y", ":FloatermNew --title=Yazi --titleposition=center yazi --cwd-file ~/.cache/yazi/last_dir %<cr>", silent = true, desc = "Open Yazi" },
      { "<leader>y", ":FloatermNew --title=Yazi --titleposition=center yazi --cwd-file ~/.cache/yazi/last_dir %<cr>", silent = true, desc = "Open Yazi" },
    },
    cmd = { "FloatermToggle", "FloatermNew" },
    config = function()
      local function calcFloatSize()
        return {
          width = math.min(math.ceil(vim.fn.winwidth(0) * 0.97), 180),
          height = math.min(math.ceil(vim.fn.winheight(0) * 0.8), 45),
        }
      end

      local function recalcFloatermSize()
        vim.g.floaterm_width = calcFloatSize().width
        vim.g.floaterm_height = calcFloatSize().height
      end

      vim.api.nvim_create_augroup("floaterm", { clear = true })
      vim.api.nvim_create_autocmd("VimResized", {
        pattern = { "*" },
        callback = recalcFloatermSize,
        group = "floaterm",
      })

      vim.g.floaterm_width = calcFloatSize().width
      vim.g.floaterm_height = calcFloatSize().height
      vim.g.floaterm_opener = "edit"
    end,
  },
  {
    "quarto-dev/quarto-nvim",
    dev = false,
    ft = { "quarto" },
    dependencies = {
      {
        "jmbuhr/otter.nvim",
        dependencies = {
          { "neovim/nvim-lspconfig" },
        },
        config = true,
      },
    },
    opts = {
      lspFeatures = {
        languages = { "r", "python", "julia", "bash", "lua", "html" },
      },
      codeRunner = {
        enabled = true,
        default_method = "molten",
      },
    },
    config = function(_, opts)
      require("quarto").setup(opts)
      local runner = require "quarto.runner"
      vim.keymap.set("n", "<localleader>qc", runner.run_cell, { desc = "run cell" })
      vim.keymap.set("n", "<localleader>qa", runner.run_above, { desc = "run cell and above" })
      vim.keymap.set("n", "<localleader>qA", runner.run_all, { desc = "run all cells" })
      vim.keymap.set("n", "<localleader>ql", runner.run_line, { desc = "run line" })
      vim.keymap.set("v", "<localleader>qr", runner.run_range, { desc = "run visual range" })
      vim.keymap.set("n", "<localleader>qA", function()
        runner.run_all(true)
      end, { desc = "run all cells of all languages" })
    end,
  },

  {
    "benlubas/molten-nvim",
    -- dependencies = { "3rd/image.nvim" },
    build = ":UpdateRemotePlugins",
    keys = { { "<localleader>mi", ":MoltenInit<cr>", desc = "Molten - init kernel" } },
    config = function()
      vim.g.molten_use_border_highlights = true
      -- add a few new things
      -- vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_image_provider = "none"
      -- vim.g.molten_virt_text_output = true
      vim.g.molten_virt_text_max_lines = 50
      vim.g.molten_use_border_highlights = true

      vim.keymap.set("n", "<localleader>mi", ":MoltenInit<CR>")
      vim.keymap.set("n", "<localleader>me", ":MoltenEvaluateOperator<CR>")
      vim.keymap.set("n", "<localleader>ml", ":MoltenEvaluateLine<CR>")
      vim.keymap.set("n", "<localleader>mr", ":MoltenReevaluateCell<CR>")
      vim.keymap.set("v", "<localleader>mr", ":<C-u>MoltenEvaluateVisual<CR>gv")
      vim.keymap.set("n", "<localleader>mo", ":noautocmd MoltenEnterOutput<CR>")
      vim.keymap.set("n", "<localleader>mh", ":MoltenHideOutput<CR>")
      vim.keymap.set("n", "<localleader>md", ":MoltenDelete<CR>")
    end,
  },

  {
    "3rd/image.nvim",
    enabled = false,
    ft = { "quarto" },
    init = function()
      package.path = package.path .. ";" .. vim.fn.expand "$HOME" .. "/.luarocks/share/lua/5.1/?/init.lua;"
      package.path = package.path .. ";" .. vim.fn.expand "$HOME" .. "/.luarocks/share/lua/5.1/?.lua;"
    end,
    opts = {
      backend = "kitty",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = true,
          download_remote_images = true,
          only_render_image_at_cursor = true,
          filetypes = { "markdown", "quarto" }, -- markdown extensions (ie. quarto) can go here
        },
      },
      max_width = 100,
      max_height = 20,
      max_height_window_percentage = math.huge,
      max_width_window_percentage = math.huge,
      kitty_method = "normal",
      window_overlap_clear_enabled = true,
      editor_only_render_when_focused = true, -- auto show/hide images when the editor gains/looses focus
      tmux_show_only_in_active_window = true, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    },
  },

  {
    "luukvbaal/statuscol.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = function()
      local builtin = require "statuscol.builtin"
      return {
        -- relculright = true,
        ft_ignore = { "toggleterm", "neogitstatus", "NvimTree" },
        bt_ignore = { "terminal" },
        segments = {
          { text = { " " } },
          { sign = { namespace = { "diagnostic/signs" }, name = { "Dap*" } }, click = "v:lua.ScSa" },
          {
            text = { "", builtin.lnumfunc, "" },
            condition = { true, builtin.not_empty },
            click = "v:lua.ScLa",
          },
          { text = { " ", builtin.foldfunc, auto = false }, click = "v:lua.ScFa" },
          { sign = { namespace = { "gitsign*" } }, click = "v:lua.ScSa" },
        },
      }
    end,
    config = function(_, opts)
      require("statuscol").setup(opts)
    end,
  },

  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    opts = {
      pre_hook = function()
        return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
      end,
    },
    config = function(_, opts)
      require("Comment").setup(opts)
    end,
  },

  {
    "mikavilpas/yazi.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      {
        "-",
        function()
          require("yazi").yazi()
        end,
        desc = "Open Yazi",
      },
    },
    opts = {
      open_for_directories = false,
    },
  },

  {
    "kazhala/close-buffers.nvim",
    keys = {
      {
        "<leader>bk",
        -- "<cmd>lua vim.cmd('Alpha'); require('close_buffers').wipe({ type = 'other', force = false })<CR>",
        "<cmd>lua vim.cmd('Dashboard'); require('close_buffers').wipe({ type = 'other', force = false })<CR>",
        noremap = true,
        silent = false,
        desc = "Close all and show Dashboard",
      },
      {
        "<leader>bo",
        "<cmd>lua require('close_buffers').wipe({ type = 'other', force = false })<CR>",
        noremap = true,
        silent = false,
        desc = "Close all other buffers",
      },
    },
  },

  {
    "mrcjkb/rustaceanvim",
    version = "^4", -- Recommended
    ft = { "rust" },
    opts = require("configs.rustaceanvim").opts,
    config = function(_, opts)
      vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
    end,
  },

  {
    "michaeljsmith/vim-indent-object",
    event = { "BufReadPost", "BufNewFile" },
  },

  {
    "RRethy/vim-illuminate",
    event = { "BufReadPre", "BufNewFile" },
    opts = require("configs.vim-illuminate").opts,
    config = function(_, opts)
      require("illuminate").configure(opts)
      require("configs.vim-illuminate").setup()
    end,
    keys = require("configs.vim-illuminate").keys,
  },

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
    "HakonHarnes/img-clip.nvim",
    cmd = { "PasteImage", "ImgClipDebug" },
    opts = {
      default = {
        embed_image_as_base64 = false,
        prompt_for_file_name = false,
        drag_and_drop = {
          insert_mode = true,
        },
      },
    },
    keys = {
      { "<leader>pi", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
    },
  },
}
