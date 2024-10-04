local command = vim.api.nvim_create_user_command
local opts = { noremap = true, silent = true }

local keymap = function(mode, keys, cmd, options)
  options = options or {}
  options = vim.tbl_deep_extend("force", opts, options)
  vim.api.nvim_set_keymap(mode, keys, cmd, options)
end

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- Redraw statusline on different events
vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("Status_GitUpdate", { clear = true }),
  pattern = "GitSignsUpdate",
  callback = vim.schedule_wrap(function()
    vim.cmd "redrawstatus"
  end),
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup "highlight_yank",
  callback = function()
    vim.highlight.on_yank { timeout = 70 }
  end,
})

-- Redraw statusline on different events
vim.api.nvim_create_autocmd("DiagnosticChanged", {
  group = vim.api.nvim_create_augroup("Status_Diagnostics", { clear = true }),
  callback = vim.schedule_wrap(function()
    vim.cmd "redrawstatus"
    vim.cmd "redrawtabline"
  end),
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("last_loc", { clear = true }),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("close_with_q", { clear = true }),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "query",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Typst
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup "typst",
  pattern = { "*.typ" },
  command = "set filetype=typst",
})

-- Wrap text and spelling for some markdown files and others
vim.api.nvim_create_autocmd("FileType", {
  group = augroup "md-tex-aucmd",
  pattern = { "markdown", "tex", "typst", "quarto" },
  callback = function()
    vim.cmd "setlocal wrap"
    vim.cmd "setlocal spell spelllang=en_us"
  end,
})

-- insert mode in terminal windows
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  group = augroup "user_terminal",
  callback = function()
    if vim.bo.buftype == "terminal" then
      vim.cmd "startinsert"
    end
  end,
})

-- Commands

-- Code Run Script
command("CodeRun", function()
  -- vim.cmd "execute '!~/scripts/code_run \"%\"'"
  require("noice").redirect "execute '!~/scripts/code_run \"%\"'"
end, {})
keymap("n", "<leader>cr", ":CodeRun<cr>", { desc = "Run code - own script" })

-- Open markdown in Deckset
command("OpenDeckset", "execute 'silent !open -a Deckset \"%\"'", {})

-- Reveal file in finder without changing the working dir in vim
command("RevealInFinder", "execute 'silent !open -R \"%\"'", {})
keymap("n", "<leader>;", ":RevealInFinder<cr>", { desc = "Reveal in finder" })

-- toggle more info in the statusline
command("StatusMoreInfo", function()
  _G.show_more_info = not _G.show_more_info
  vim.cmd "redrawstatus!"
end, {})
keymap("n", "<leader>ti", ":StatusMoreInfo<cr>", { desc = "Status more info" })

command("OpenGithubRepo", function()
  local mode = vim.api.nvim_get_mode().mode
  local text = ""

  if mode == "v" then
    text = vim.getVisualSelection()
    vim.fn.setreg('"', text) -- yank the selected text
  else
    local node = vim.treesitter.get_node() --[[@as TSNode]]
    -- Get the text of the node
    text = vim.treesitter.get_node_text(node, 0)
  end

  if text:match "^[%w%-%.%_%+]+/[%w%-%.%_%+]+$" == nil then
    local msg = string.format("OpenGithubRepo: '%s' Invalid format. Expected 'foo/bar' format.", text)
    vim.notify(msg, vim.log.levels.ERROR)
    return
  end

  local url = string.format("https://www.github.com/%s", text)
  print("Opening", url)
  vim.ui.open(url)
end, {})
vim.keymap.set({ "n", "v" }, "<leader>og", "<cmd>OpenGithubRepo<cr>", { desc = "Open Github Repo" })

-- open same file in nvim in a new tmux pane
command("NewTmuxNvim", function()
  if os.getenv "TERM_PROGRAM" == "tmux" and vim.fn.expand("%"):len() > 0 then
    -- vim.cmd("execute 'silent !tmux new-window nvim %'")
    vim.cmd "execute 'silent !tmux split-window -h nvim %'"
  else
    print "Nothing to open..."
  end
end, {})
keymap("n", "<leader>on", "<cmd>NewTmuxNvim<cr>", { desc = "Same file in TMUX window" })

-- Convert markdown file to pdf using pandoc
command("MdToPdf", 'execute \'silent !pandoc "%" --listings -H ~/.config/pandoc/listings-setup.tex -o "%:r.pdf"\'', {})
command(
  "MdToPdfNumbered",
  'execute \'silent !pandoc "%" --listings -H ~/.config/pandoc/listings-setup.tex -o "%:r.pdf" --number-sections\'',
  {}
)
command("MdToPdfWatch", function()
  if _G.fswatch_job_id then
    print "Fswatch job already running."
    return
  end
  vim.cmd 'execute \'silent !pandoc "%" --listings -H ~/.config/pandoc/listings-setup.tex -L ~/.config/pandoc/pagebreak.lua --include-in-header ~/.config/pandoc/header.tex -o "%:r.pdf"\''
  local cmd = string.format(
    'fswatch -o "%s" | xargs -n1 -I{} pandoc "%s" --listings -H ~/.config/pandoc/listings-setup.tex -L ~/.config/pandoc/pagebreak.lua --include-in-header ~/.config/pandoc/header.tex -o "%s.pdf"',
    vim.fn.expand "%:p",
    vim.fn.expand "%:p",
    vim.fn.expand "%:r"
  )
  _G.fswatch_job_id = vim.fn.jobstart(cmd)
  if _G.fswatch_job_id ~= 0 then
    print "Started watching file changes."
    vim.cmd "execute 'silent !zathura \"%:r.pdf\" & ~/scripts/focus_app zathura'"
  else
    print "Failed to start watching file changes."
  end
end, {})

-- Stop watching markdown file changes
command("StopMdToPdfWatch", function()
  if _G.fswatch_job_id then
    vim.fn.jobstop(_G.fswatch_job_id)
    print "Stopped watching file changes."
    _G.fswatch_job_id = nil
  else
    print "No fswatch process found."
  end
end, {})

vim.keymap.set("n", "<leader>mw", function()
  if _G.fswatch_job_id then
    vim.cmd "StopMdToPdfWatch"
  else
    vim.cmd "MdToPdfWatch"
  end
end, { desc = "MarkdowntoPDFWatch Toggle" })

-- Convert markdown file to docx using pandoc
command("MdToDocx", 'execute \'silent !pandoc "%" -o "%:r.docx"\'', {})

-- Convert markdown file to Beamer presentation using pandoc
command("MdToBeamer", 'execute \'silent !pandoc "%" -t beamer -o "%:r.pdf"\'', {})

command("LuaInspect", function()
  local sel = vim.fn.mode() == "v" and vim.getVisualSelection() or nil
  if sel then
    local chunk, load_error = load("return " .. sel)
    if chunk then
      local success, result = pcall(chunk)
      if success then
        vim.notify(vim.inspect(result), vim.log.levels.INFO)
      else
        vim.notify("Error evaluating expression: " .. result, vim.log.levels.ERROR)
      end
    else
      vim.notify("Error loading expression: " .. load_error, vim.log.levels.ERROR)
    end
  else
    vim.api.nvim_feedkeys(":lua print(vim.inspect())", "n", true)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Left><Left>", true, false, true), "n", true)
  end
end, {})
vim.keymap.set({ "n", "v" }, "<leader>pi", "<cmd>LuaInspect<cr>", { desc = "Lua Inspect" })

command("LuaPrint", function()
  if vim.fn.mode() == "v" then
    vim.cmd "LuaInspect"
  else
    vim.api.nvim_feedkeys(":lua print()", "n", true)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Left>", true, false, true), "n", true)
  end
end, {})
vim.keymap.set({ "n", "v" }, "<leader>pp", "<cmd>LuaPrint<cr>", { desc = "Lua Print" })
