local o = vim.opt

-- Mouse: click, drag-select, scroll, resize splits, right-click menu
o.mouse = "a"
o.mousemodel = "popup_setpos" -- right click moves cursor, then opens menu
o.mousemoveevent = true       -- lets plugins react to hover

-- UI
o.number = true
o.relativenumber = true
o.cursorline = true
o.signcolumn = "yes"
o.termguicolors = true
o.scrolloff = 8
o.sidescrolloff = 8
o.laststatus = 3   -- single global statusline
o.cmdheight = 1
o.showmode = false -- lualine shows the mode
o.wrap = false
o.breakindent = true
o.list = true
o.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
o.fillchars = { eob = " " }
o.pumheight = 12
vim.o.winborder = "rounded" -- Neovim 0.11+

-- Splits
o.splitright = true
o.splitbelow = true

-- Search
o.ignorecase = true
o.smartcase = true
o.inccommand = "split"

-- Editing
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.smartindent = true
o.confirm = true

-- Files / performance
o.undofile = true
o.swapfile = false
o.updatetime = 250
o.timeoutlen = 300

-- Python options
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Share clipboard with the system (scheduled to avoid slowing startup)
vim.schedule(function()
  o.clipboard = "unnamedplus"
end)

-- Right-click context menu: tidy the defaults and add LSP actions
vim.schedule(function()
  pcall(vim.cmd.aunmenu, [[PopUp.How-to\ disable\ mouse]])
  pcall(vim.cmd.aunmenu, [[PopUp.-1-]])
  vim.cmd([[amenu PopUp.Go\ to\ Definition   <cmd>lua vim.lsp.buf.definition()<CR>]])
  vim.cmd([[amenu PopUp.Find\ References     <cmd>lua vim.lsp.buf.references()<CR>]])
  vim.cmd([[amenu PopUp.Rename\ Symbol       <cmd>lua vim.lsp.buf.rename()<CR>]])
  vim.cmd([[amenu PopUp.Code\ Action         <cmd>lua vim.lsp.buf.code_action()<CR>]])
  vim.cmd([[amenu PopUp.Format\ Buffer       <cmd>lua require("conform").format({ lsp_format = "fallback" })<CR>]])
end)
