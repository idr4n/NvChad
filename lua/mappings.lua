require "nvchad.mappings"

-- add yours here

local utils = require "utils"

--: helpers {{{
--: https://github.com/nvim-telescope/telescope.nvim/issues/1923
function vim.getVisualSelection()
  vim.cmd 'noau normal! "vy"'
  local text = tostring(vim.fn.getreg "v")
  vim.fn.setreg("v", {})

  text = string.gsub(text, "\n", "")
  if #text > 0 then
    return text
  else
    return ""
  end
end
--: }}}

local opts = { noremap = true, silent = true }

local keymap = function(mode, keys, cmd, options)
  options = options or {}
  options = vim.tbl_deep_extend("force", opts, options)
  vim.api.nvim_set_keymap(mode, keys, cmd, options)
end

local keyset = function(modes, keys, cmd, options)
  options = options or {}
  options = vim.tbl_deep_extend("force", opts, options)
  vim.keymap.set(modes, keys, cmd, options)
end

keyset("n", ";", ":", { desc = "CMD enter command mode" })

keyset("n", "<leader>fm", function()
  require("conform").format { async = true, lsp_fallback = true }
end, { desc = "File Format with conform" })

keymap("i", "jk", "<ESC>", { desc = "Exit insert mode" })
keyset("v", "<C-g>", "<ESC>")
keymap("n", "ga", ":b#<CR>zz", { desc = "Last buffer" })
keyset({ "n", "v", "o" }, "gh", "0", { desc = "Go to start of line" })
keyset({ "n", "o" }, "gl", "$", { desc = "Go to end of line" })
keyset("v", "gl", "$h", { desc = "Go to end of line" })
keymap("n", "g;", "^v$h", { desc = "Select line-no-end" })
keymap("n", "yg", "^v$hy", { desc = "Yank line-no-end" })
keymap("n", "gcy", "gcc:t.<cr>gcc", { noremap = false, desc = "Duplicate-comment line" })
keymap("v", "gy", ":t'><cr>gvgcgv<esc>", { noremap = false, desc = "Duplicate and comment" })
keymap("n", "<Leader>W", "<cmd>noa w<CR>", { desc = "Save file without formatting" })
keymap("n", "z1", "zMzr", { desc = "Fold level 1" })
-- keymap("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
-- keymap("n", "<S-Tab>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
keyset("n", "<Tab>", function()
  require("nvchad.tabufline").next()
end, { desc = "Next buffer" })
keyset("n", "<S-Tab>", function()
  require("nvchad.tabufline").prev()
end, { desc = "Previous buffer" })
keyset("n", "<S-L>", function()
  require("nvchad.tabufline").next()
end, { desc = "Next buffer" })
keyset("n", "<S-H>", function()
  require("nvchad.tabufline").prev()
end, { desc = "Previous buffer" })
keymap("n", "<leader>zl", "<cmd>lopen<cr>", { desc = "Location List" })
keymap("n", "<leader>zq", "<cmd>copen<cr>", { desc = "Quickfix List" })
keyset("n", "<leader>ol", "<cmd>:Lazy<cr>", { desc = "Lazy Dashboard" })
keyset("n", "<leader>op", "<cmd>e#<cr>", { desc = "Reopen buffer" })
keyset({ "n", "i", "x", "s" }, "<C-S>", "<cmd>w<CR><esc>", { desc = "Save file" })

-- Clear search with <esc>
keyset(
  { "i", "n" },
  "<esc>",
  "<esc><cmd>noh<cr><cmd>redrawstatus<cr><cmd>echon ''<cr>",
  { desc = "Escape and clear hlsearch" }
)

--: Move up and down with wrapped lines {{{
keymap("n", "j", "gj")
keymap("n", "k", "gk")
--: }}}

--: search for word under cursor and stays there {{{
-- searches exact word (* forward, # backwards)
keymap("n", "*", "*N", { desc = "Search exact" })
keymap("n", "#", "#N", { desc = "Search exact backwards" })
-- searches but not the exact word (* forward, # backwards)
keymap("n", "g*", "g*N", { desc = "Search not exact" })
keymap("n", "g#", "g#N", { desc = "BckSearch not exact" })
-- search for highlighted text
keymap("v", "*", "y/\\V<C-R>=escape(@\",'/')<CR><CR>N", { desc = "Search for highlighted text" })
--: }}}

--: Move text up and down
keymap("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
keymap("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
keymap("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
keymap("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
keymap("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move line down" })
keymap("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move line up" })

--: Insert line above and below
-- stylua: ignore
keymap("i", "<C-O>", "<C-o>O", { desc = "Insert line above" })
-- source: https://arc.net/l/quote/bexrxjgz
-- stylua: ignore
keymap("n", "]<space>", "<cmd>call append(line('.'),   repeat([''], v:count1))<cr>", { desc = "Insert line below" })
-- stylua: ignore
keymap("n", "[<space>", "<cmd>call append(line('.')-1, repeat([''], v:count1))<cr>", { desc = "Insert line above" })

--: Add undo break-points
keymap("i", ",", ",<c-g>u")
keymap("i", ".", ".<c-g>u")
keymap("i", ";", ";<c-g>u")
keymap("i", "<Space>", "<Space><c-g>u")

--: move around cursor center and top {{{
keyset("n", "<C-z>", "zz", { desc = "Center around cursor" })
keyset("i", "<C-z>", "<C-O>zz", { desc = "Center around cursor" })
--: }}}

--: Move around while in insert mode
keymap("i", "<C-a>", "<Home>")
keymap("i", "<C-e>", "<End>")
keymap("i", "<C-b>", "<Left>")
keymap("i", "<A-b>", "<ESC>bi")
keymap("i", "<C-f>", "<Right>")
keymap("i", "<A-f>", "<ESC>lwi")

--: toggle comment in normal mode
keyset("n", "<C-c>", function()
  return vim.v.count == 0 and "<Plug>(comment_toggle_linewise_current)" or "<Plug>(comment_toggle_linewise_count)"
end, { expr = true })
keyset("n", "<C-b>", "<Plug>(comment_toggle_blockwise_current)")
-- toggle comment in visual mode
keyset("x", "<C-c>", "<Plug>(comment_toggle_linewise_visual)", { desc = "Comment line(s)" })
keyset("x", "<C-b>", "<Plug>(comment_toggle_blockwise_visual)", { desc = "Comment block" })

--: Move cursor around {{{
keyset({ "n", "v" }, "<C-l>", function()
  -- insert mode is defined in the nvim-cmp config
  utils.cursorMoveAround()
end, { desc = "Move Around Cursor" })
--: }}}

-- Nvimtree
keyset("n", "<C-n>", ":lua require('nvim-tree.api').tree.toggle({ focus = false })<CR>", { desc = "Toggle nvimtree" })

--: toggle wrapping lines {{{
keymap("n", "<leader>tw", "<cmd>set wrap!<cr>", { desc = "Toggle line wrap" })
--: }}}

--: Quit current window {{{
keymap("n", "<leader>qq", ":qa<CR>", { desc = "Quit all" })
keymap("n", "<leader>qw", ":q<CR>", { desc = "Quit window" })
keymap("n", "<leader>qQ", ":q!<CR>", { desc = "Force Quit" })
--: }}}

-- Tabs
keymap("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
keymap("n", "<S-Tab>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })

-- Toggle theme
keyset("n", "<leader>tt", function()
  require("base46").toggle_theme()
  -- toggle_theme()
end, { desc = "Toggle Theme" })

-- Toggle term
keyset({ "n", "t" }, "<C-\\>", function()
  require("nvchad.term").toggle { pos = "vsp", id = "vtoggleTerm", size = 0.4 }
end, { desc = "Terminal Toggleable vertical term" })

keyset({ "n", "t" }, "<A-/>", function()
  require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm", size = 0.3 }
end, { desc = "Terminal New horizontal term" })

keyset({ "n", "t" }, "<M-`>", function()
  require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm", size = 0.3 }
end, { desc = "Terminal New horizontal term" })

keyset({ "n", "t" }, "<A-\\>", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end, { desc = "Terminal Toggle Floating term" })

--: Better indent
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

--: Replace the easy-clip plugin
keymap("x", "p", '"_dP')
keymap("n", "d", '"_d')
keymap("n", "D", '"_D')
keymap("v", "d", '"_d')
keyset("n", "gm", "m", { desc = "Add mark" })
keymap("", "m", "d")
keymap("", "M", "D")
keymap("", "<leader>m", '"+d', { desc = "Cut to clipboard" })
keymap("n", "x", '"_x')
keymap("n", "X", '"_X')
keyset({ "n", "x", "o" }, "c", '"_c')
keymap("n", "cc", '"_cc')
keymap("n", "cl", '"_cl')
keymap("n", "ce", '"_ce')
keymap("n", "ci", '"_ci')
keymap("n", "C", '"_C')
keymap("v", "x", '"_x')
-- keymap("v", "c", '"_c')

--: Maximize window {{{
vim.b.is_zoomed = false
vim.w.original_window_layout = {}

local function toggle_maximize_buffer()
  if not vim.b.is_zoomed then
    -- Save the current window layout
    vim.w.original_window_layout = vim.api.nvim_call_function("winrestcmd", {})
    -- Maximize the current window
    vim.cmd "wincmd _"
    vim.cmd "wincmd |"
    vim.b.is_zoomed = true
  else
    -- Restore the previous window layout
    vim.api.nvim_call_function("execute", { vim.w.original_window_layout })
    vim.b.is_zoomed = false
  end
end
keyset({ "n", "t" }, "<A-,>", toggle_maximize_buffer, { desc = "Maximize buffer" })
--: }}}

-- smart window cycle with c-t {{{
local function is_tree_window()
  local buftype = vim.bo.buftype
  local filetype = vim.bo.filetype
  return buftype == "nofile" and (filetype == "neo-tree" or filetype == "NvimTree")
end

keyset({ "n", "t" }, "<C-t>", function()
  if vim.b.is_zoomed then
    vim.b.is_zoomed = false
    vim.api.nvim_call_function("execute", { vim.w.original_window_layout })
    vim.cmd "wincmd w"
  else
    vim.cmd "wincmd w"
    if is_tree_window() then
      vim.cmd "wincmd w"
    end
  end
end, { desc = "Smart next window" })
--: }}}

--: Easy select all of file {{{
keymap("n", ",A", "ggVG<c-$>", { desc = "Select All" })
--: }}}

--: diagnostics {{{
-- souce: https://github.com/LazyVim/LazyVim
local diagnostic_goto = function(next, severity)
  severity = severity and vim.diagnostic.severity[severity] or nil
  local opt = next and { count = 1, float = true, severity = severity } or { count = -1, float = true, severity }
  return function()
    vim.diagnostic.jump(opt)
  end
end
keyset("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
keyset("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
keyset("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
keyset("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
keyset("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
keyset("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
keyset("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })
--: }}}

--: terminal {{{
keymap("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
--: }}}

-- Delete some default mappings
-- vim.keymap.del("n", "<C-n>")
vim.keymap.del("n", "<leader>rn")
vim.keymap.del("n", "<leader>h")
vim.keymap.del("n", "<leader>v")
vim.keymap.del("n", "<leader>b")
vim.keymap.del("n", "<A-v>")
vim.keymap.del("n", "<A-h>")
vim.keymap.del("n", "<A-i>")
vim.keymap.del("n", "<leader>n")
