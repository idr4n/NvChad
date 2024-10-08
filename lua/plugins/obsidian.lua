return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  ft = "markdown",
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

  opts = {
    ui = { enable = false },
    workspaces = {
      {
        name = "personal",
        path = "~/pCloud/Notes-Database",
        overrides = {
          notes_subdir = "00-Inbox",
        },
      },
      {
        name = "work",
        path = "~/pCloud/Notes-tdo",
        overrides = {
          notes_subdir = "notes",
        },
      },
      -- Usage outside of a workspace or vault
      {
        name = "no-vault",
        path = function()
          -- alternatively use the CWD:
          -- return assert(vim.fn.getcwd())
          return assert(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
        end,
        overrides = {
          notes_subdir = vim.NIL, -- have to use 'vim.NIL' instead of 'nil'
          new_notes_location = "current_dir",
          templates = {
            subdir = vim.NIL,
          },
        },
      },
    },
    new_notes_location = "notes_subdir",
    disable_frontmatter = true,
    mappings = {
      -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
      ["gf"] = {
        action = function()
          return require("obsidian").util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true, desc = "Obsidian Follow Link" },
      },
      -- Toggle check-boxes.
      ["<leader>oc"] = {
        action = function()
          return require("obsidian").util.toggle_checkbox()
        end,
        opts = { buffer = true, desc = "Toggle check-boxes" },
      },
    },
  },
}
