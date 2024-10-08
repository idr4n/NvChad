-- To find any highlight groups: "<cmd> Telescope highlights"
-- Each highlight group can take a table with variables fg, bg, bold, italic, etc
-- base30 variable names can also be used as colors

local M = {}

---@type Base46HLGroupsList
M.override = {
  -- Comment = {
  --   italic = true,
  -- },
  -- ["@comment"] = { italic = true },
  -- ["@ibl.scope.underline.1"] = { bg = "one_bg2" },
  NonText = { fg = "one_bg" },
}

---@type HLTable
M.add = {
  -- NvimTreeOpenedFolderName = { fg = "green", bold = true },
  St_Stealth = { fg = { "light_grey", 2 }, bg = "statusline_bg" },
  St_Stealth_light = { fg = { "light_grey", 7 }, bg = "statusline_bg" },
  St_Status = { fg = "light_grey", bg = "statusline_bg" },
  St_Status1 = { fg = { "light_grey", 7 }, bg = { "black", 7 } },
  St_Status1_light = { fg = { "light_grey", -10 }, bg = { "black", -13 } },
  St_Status2 = { fg = { "light_grey", 15 }, bg = { "black", 10 } },

  -- modes hl_groups
  St_Pink = { fg = "black", bg = "baby_pink", bold = true },
  St_Green = { fg = "black", bg = "green", bold = true },
  St_Blue = { fg = "black", bg = "nord_blue", bold = true },
  St_Yellow = { fg = "black", bg = "yellow", bold = true },
  St_Purple = { fg = "black", bg = "purple", bold = true },
  St_Orange = { fg = "black", bg = "orange", bold = true },
  St_Red = { fg = "black", bg = "red", bold = true },

  BufferLineOffsetSeparator = { fg = "darker_black", bg = "darker_black" },

  ColorColum = { bg = "black2" },
  RenderMarkdownCode = { link = "ColorColum" },
  RenderMarkdownH1Bg = { fg = "green" },
  RenderMarkdownH2Bg = { fg = "purple" },
  RenderMarkdownH3Bg = { fg = "yellow" },
  RenderMarkdownH4Bg = { fg = "orange" },
  RenderMarkdownH5Bg = { fg = "orange" },
  RenderMarkdownH6Bg = { fg = "orange" },

  NoiceCmdlinePopUp = { bg = "statusline_bg" },
}

return M
