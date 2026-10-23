local au = vim.api.nvim_create_autocmd
local group = vim.api.nvim_create_augroup("user_config", { clear = true })

au("TextYankPost", {
  group = group,
  desc = "Flash yanked text",
  callback = function() vim.hl.on_yank() end,
})

au("BufReadPost", {
  group = group,
  desc = "Restore last cursor position",
  callback = function(ev)
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    local lines = vim.api.nvim_buf_line_count(ev.buf)
    if mark[1] > 0 and mark[1] <= lines then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

au("VimResized", {
  group = group,
  desc = "Keep splits equal when the terminal resizes",
  command = "tabdo wincmd =",
})

au("FileType", {
  group = group,
  desc = "Close utility windows with q",
  pattern = { "help", "qf", "man", "checkhealth", "lspinfo" },
  callback = function(ev)
    vim.bo[ev.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = ev.buf, silent = true })
  end,
})
