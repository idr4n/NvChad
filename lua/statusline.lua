local M = {}

local utils = require "utils"

local modes = {
  ["n"] = "N",
  ["no"] = "N(no)",
  ["nov"] = "N(nov)",
  ["noV"] = "N(noV)",
  ["noCTRL-V"] = "N",
  ["niI"] = "Ni",
  ["niR"] = "Nr",
  ["niV"] = "Nv",
  ["nt"] = "NT",
  ["ntT"] = "NT(ntT)",

  ["v"] = "V",
  ["vs"] = "V-CH",
  ["V"] = "V-L",
  ["Vs"] = "V-L",
  [""] = "C-V",

  ["i"] = "I",
  ["ic"] = "I(completion)",
  ["ix"] = "I(completion)",

  ["t"] = "T",

  ["R"] = "R",
  ["Rc"] = "R(Rc)",
  ["Rx"] = "R(Rx)",
  ["Rv"] = "V-R",
  ["Rvc"] = "V-R(Rvc)",
  ["Rvx"] = "V-R(Rvx)",

  ["s"] = "S",
  ["S"] = "S-L",
  [""] = "S-B",
  ["c"] = "C",
  ["cv"] = "C",
  ["ce"] = "C",
  ["r"] = "PROMPT",
  ["rm"] = "MORE",
  ["r?"] = "CONFIRM",
  ["x"] = "CONFIRM",
  ["!"] = "SHELL",
}

local modes_colors = {
  n = "St_Blue",
  i = "St_Green",
  v = "St_Pink",
  V = "St_Pink",
  ["\22"] = "St_Pink",
  c = "St_Yellow",
  s = "St_Purple",
  S = "St_Purple",
  ["\19"] = "St_Purple",
  R = "St_Red",
  r = "St_Red",
  ["!"] = "St_Orange",
  t = "St_Green",
  ["nt"] = "St_Green",
}

function M.mode()
  if not (vim.api.nvim_get_current_win() == vim.g.statusline_winid) then
    return ""
  end
  local m = vim.api.nvim_get_mode().mode
  return "%#St_Mode#" .. " " .. modes[m] .. " "
end

function M.color_mode()
  if not (vim.api.nvim_get_current_win() == vim.g.statusline_winid) then
    return ""
  end

  local m = vim.api.nvim_get_mode().mode
  -- return string.format("%#%s#", modes_colors[m]) .. " " .. modes[m] .. " "
  return "%#" .. modes_colors[m] .. "#" .. " " .. modes[m] .. " "
end

function M.hl_stealth()
  return vim.o.background == "dark" and "%#St_Stealth#" or "%#St_Stealth_light#"
end

function M.filetype()
  local hl = vim.o.background == "dark" and "%#St_Status1#" or "%#St_Status1_light#"
  -- local hl = "%#St_Mode#"
  local ft = vim.bo.filetype:upper()
  return (ft == "" and hl .. " PLAIN TEXT ") or (hl .. " " .. ft .. " ")
end

function M.cwd()
  local name = ""
  local m = vim.api.nvim_get_mode().mode
  name = "%#" .. modes_colors[m] .. "#" .. "  " .. vim.loop.cwd():match "([^/\\]+)[/\\]*$" .. " "
  return (vim.o.columns > 85 and name) or ""
end

function M.LSP_Diagnostics()
  local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR }) --[[@as string]]
  local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN }) --[[@as string]]
  local hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT }) --[[@as string]]
  local info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO }) --[[@as string]]

  local diagnostics = errors + warnings + hints + info

  if diagnostics == 0 then
    return ""
  end

  errors = (errors and errors > 0) and (" " .. errors .. " ") or ""
  warnings = (warnings and warnings > 0) and (" " .. warnings .. " ") or ""
  -- hints = (hints and hints > 0) and ("󰛩 " .. hints .. " ") or ""
  hints = (hints and hints > 0) and ("󰌵 " .. hints .. " ") or ""
  info = (info and info > 0) and (" " .. info .. " ") or ""

  return (diagnostics > 0 and " ") .. errors .. warnings .. hints .. info
end

function M.fileblock()
  local icon = "󰈚 "
  local dir = utils.pretty_dirpath()()
  local path = vim.fn.expand "%:t"
  -- local path = vim.api.nvim_buf_get_name(stbufnr())
  local name = (path == "" and "Empty ") or path:match "([^/\\]+)[/\\]*$"

  if name ~= "Empty " then
    local devicons_present, devicons = pcall(require, "nvim-web-devicons")

    if devicons_present then
      local ft_icon = devicons.get_icon(name)
      icon = (ft_icon ~= nil and ft_icon) or icon
    end

    name = name .. " "
  end

  return " " .. icon .. " " .. dir .. name
end

function M.position()
  return "%3l:%-2c %-3L "
end

function M.search_count()
  if vim.v.hlsearch == 0 then
    return ""
  end

  local ok, search = pcall(vim.fn.searchcount, { recompute = true, maxcount = 500 })
  if (not ok or (search.current == nil)) or (search.total == 0) then
    return ""
  end

  if search.incomplete == 1 then
    return "%#SLMatches# ?/? %#SLNormal#"
  end

  return string.format("  %d/%d ", search.current, math.min(search.total, search.maxcount))
end

function M.charcode()
  return " Ux%04B "
end

function M.status_mode()
  if package.loaded["noice"] and require("noice").api.status.mode.has() then
    return " " .. require("noice").api.status.mode.get() .. " "
  end
  return ""
end

local function stbufnr()
  return vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)
end

function M.lsp_running()
  if rawget(vim, "lsp") then
    for _, client in ipairs(vim.lsp.get_clients()) do
      if client.attached_buffers[stbufnr()] and client.name ~= "null-ls" then
        return (vim.o.columns > 100 and " 󰄭  " .. client.name .. " ") or " 󰄭  LSP "
      end
    end
  end

  return ""
end

function M.git_hunks()
  if not vim.b[0].gitsigns_head or vim.b[0].gitsigns_git_status then
    return ""
  end

  local hunks = require("gitsigns").get_hunks()
  local nhunks = hunks and #hunks or 0
  local branch_name = "  " .. vim.b[0].gitsigns_status_dict.head .. " "
  local status = ""
  local hunk_icon = " "
  if nhunks > 0 then
    status = " " .. hunk_icon .. nhunks
  end
  return status .. " " .. "%#St_Status1#" .. branch_name
end

M.git = function()
  if not vim.b[0].gitsigns_head or vim.b[0].gitsigns_git_status then
    return ""
  end

  local git_status = vim.b[0].gitsigns_status_dict

  local total = (git_status.added or 0) + (git_status.changed or 0) + (git_status.removed or 0)

  local added = (git_status.added and git_status.added ~= 0) and ("  " .. git_status.added) or ""
  local changed = (git_status.changed and git_status.changed ~= 0) and ("  " .. git_status.changed) or ""
  local removed = (git_status.removed and git_status.removed ~= 0) and ("  " .. git_status.removed) or ""
  -- local branch_name = "  " .. git_status.head .. (total == 0 and " " or "")
  local branch_name = "  " .. git_status.head .. " "

  -- return branch_name .. (total > 0 and added .. changed .. removed .. " " or "")
  return (total > 0 and added .. changed .. removed .. " " or "") .. branch_name
end

function M.get_words()
  if vim.bo.filetype == "md" or vim.bo.filetype == "text" or vim.bo.filetype == "markdown" then
    if vim.fn.wordcount().visual_words == nil then
      return " " .. " " .. tostring(vim.fn.wordcount().words) .. " "
    end
    return " " .. " " .. tostring(vim.fn.wordcount().visual_words) .. " "
  else
    return ""
  end
end

return M
