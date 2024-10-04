return {
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter", "BufReadPost" },
  dependencies = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lua",
    -- { "js-everts/cmp-tailwind-colors", config = true },
  },
  opts = function()
    local config = require "nvchad.configs.cmp"
    local cmp = require "cmp"
    local cursorMoveAround = require("utils").cursorMoveAround

    local check_backspace = function()
      local col = vim.fn.col "." - 1
      return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
    end

    config.mapping = {
      ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
      ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
      ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
      ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ["<C-e>"] = cmp.config.disable,
      ["<C-x>"] = cmp.mapping {
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      },
      ["<C-l>"] = cmp.mapping(function()
        if cmp.visible() then
          cmp.confirm { select = true }
        else
          cursorMoveAround()
        end
      end, { "i", "s" }),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif check_backspace() then
          fallback()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end, { "i", "s" }),
    }

    config.preselect = cmp.PreselectMode.None
    config.confirm_opts = {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    }
    config.completion = {
      completeopt = "menu,menuone,noselect",
    }

    -- config.formatting = vim.tbl_extend("force", config.formatting, {
    --   format = function(entry, item)
    --     local cmp_ui = require("nvconfig").ui.cmp
    --     local cmp_style = cmp_ui.style
    --     local icons = require "nvchad.icons.lspkind"
    --     local icon = (cmp_ui.icons and icons[item.kind]) or ""
    --
    --     -- START extra config for cmp-tailwind-colors (remove if not used)
    --     if item.kind == "Color" then
    --       item = require("cmp-tailwind-colors").format(entry, item)
    --
    --       if item.kind ~= "Color" then
    --         item.menu = "Color"
    --         item.kind = string.format(" %s", item.kind)
    --         return item
    --       end
    --     end
    --     -- END extra config for cmp-tailwind-colors
    --
    --     if cmp_style == "atom" or cmp_style == "atom_colored" then
    --       icon = " " .. icon .. " "
    --       item.menu = cmp_ui.lspkind_text and "   (" .. item.kind .. ")" or ""
    --       item.kind = icon
    --     else
    --       icon = cmp_ui.lspkind_text and (" " .. icon .. " ") or icon
    --       item.kind = string.format("%s %s", icon, cmp_ui.lspkind_text and item.kind or "")
    --       item.menu = ""
    --     end
    --
    --     return item
    --   end,
    -- })

    cmp.setup.cmdline("/", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" },
      },
    })

    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        { name = "cmdline" },
      }),
    })

    table.insert(config.sources, { name = "otter" })

    return config
  end,
}
