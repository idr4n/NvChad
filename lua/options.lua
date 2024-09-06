require "nvchad.options"

-- add yours here!

local opt = vim.opt

-- opt.cmdheight = 0
-- opt.laststatus = 0
opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
opt.conceallevel = 2 -- hide some markup such as `` and * in markdown files
opt.linebreak = true -- Break lines in spaces not in the middle of a word
-- opt.list = true -- Show some invisible characters (tabs...
opt.nrformats:append "alpha" -- increments letters sequences as well with <c-a>
opt.relativenumber = true
opt.scrolloff = 8 -- Lines of context
opt.shortmess:append { W = true, I = true, c = true, C = true, S = true }
opt.showmode = false -- Don't show mode
-- opt.showtabline = 0
opt.timeoutlen = 300
opt.wrap = false

vim.o.listchars = [[tab:──,trail:·,nbsp:␣,precedes:«,extends:»,]]
-- vim.o.cursorlineopt ='number,line'

-- load statuscolumn
opt.statuscolumn = [[%!v:lua.require'utils'.statuscolumn()]]

local enable_providers = {
  "python3_provider",
  -- "node_provider",
}

-- this is needed for plugins such as molten
for _, plugin in pairs(enable_providers) do
  vim.g["loaded_" .. plugin] = nil
  vim.cmd("runtime " .. plugin)
end
