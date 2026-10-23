local map = vim.keymap.set

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Save / quit
map({ "n", "i", "x", "s" }, "<C-s>", "<cmd>w<CR><Esc>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>qa<CR>", { desc = "Quit all" })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Resize windows
map("n", "<C-Up>", "<cmd>resize +2<CR>")
map("n", "<C-Down>", "<cmd>resize -2<CR>")
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>")
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>")

-- Buffers
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

-- Better indenting (keep selection)
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Move selected lines
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep cursor centred on jumps
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Paste over selection without clobbering the register
map("x", "<leader>p", [["_dP]], { desc = "Paste without yanking" })

-- Diagnostics
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Line diagnostics" })

-- Cheatsheet
require("config.cheatsheet")
map("n", "<leader>?", "<cmd>Cheatsheet<CR>", { desc = "Cheatsheet" })
