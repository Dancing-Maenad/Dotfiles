-- A cheatsheet built from your real keymaps (anything with a `desc`),
-- plus a short list of built-in and plugin keys that have no mapping of their own.
local M = {}

local order = { "Find", "Git", "Code", "Buffers", "Diagnostics", "Explorer", "Navigation", "General" }

local leader_sections = {
  f = "Find", g = "Git", c = "Code", r = "Code", s = "Code",
  b = "Buffers", x = "Diagnostics", e = "Explorer", E = "Explorer",
}

local static = {
  { "Navigation", "s / S", "Flash jump / treesitter select" },
  { "Navigation", "gd / gr", "Definition / references (fzf)" },
  { "Navigation", "K", "Hover docs" },
  { "Navigation", "]h / [h", "Next / previous git hunk" },
  { "Code", "gra", "Code action (built in)" },
  { "Code", "grn", "Rename (built in)" },
  { "General", "gcc / gc", "Toggle comment (built in)" },
  { "General", "gsa / gsd / gsr", "Surround: add / delete / replace" },
  { "General", "af / if / ac / ic", "Text objects: function / class" },
  { "General", "<C-\\>", "Toggle terminal" },
  { "General", "Right click", "Context menu (definition, rename, format...)" },
  { "General", "Click / double click", "Tabs, scrollbar, explorer files" },
}

local function section_for(lhs)
  local key = lhs:match("^<leader>(.)")
  if key then
    return leader_sections[key] or "General"
  end
  return "Navigation"
end

function M.open()
  local src = vim.api.nvim_get_current_buf()
  local groups, seen = {}, {}
  for _, name in ipairs(order) do groups[name] = {} end

  local function add(section, key, desc)
    local id = section .. key .. desc
    if seen[id] then return end
    seen[id] = true
    table.insert(groups[section], { key, desc })
  end

  local function collect(maps, suffix)
    for _, m in ipairs(maps) do
      local lhs = m.lhs or ""
      lhs = lhs:gsub("^ ", "<leader>")
      lhs = lhs:gsub("^<Space>", "<leader>")
      if m.desc and m.desc ~= "" and not lhs:match("^<Plug>") and not lhs:match("^<SNR>") then
        add(section_for(lhs), lhs .. (suffix or ""), m.desc)
      end
    end
  end

  collect(vim.api.nvim_get_keymap("n"))
  collect(vim.api.nvim_buf_get_keymap(src, "n"))
  collect(vim.api.nvim_get_keymap("x"), " (visual)")
  for _, s in ipairs(static) do add(s[1], s[2], s[3]) end

  local lines, marks = { "  Cheatsheet   (q or <Esc> to close)", "" }, {}
  marks[#marks + 1] = { 0, "Title" }
  for _, name in ipairs(order) do
    local items = groups[name]
    if #items > 0 then
      table.sort(items, function(a, b) return a[1] < b[1] end)
      lines[#lines + 1] = "  " .. name
      marks[#marks + 1] = { #lines - 1, "Function" }
      for _, it in ipairs(items) do
        lines[#lines + 1] = string.format("    %-24s %s", it[1], it[2])
        marks[#marks + 1] = { #lines - 1, "Special", 4, 4 + #it[1] }
      end
      lines[#lines + 1] = ""
    end
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  local ns = vim.api.nvim_create_namespace("cheatsheet")
  for _, m in ipairs(marks) do
    vim.api.nvim_buf_set_extmark(buf, ns, m[1], m[3] or 0, {
      end_col = m[4] or #lines[m[1] + 1],
      hl_group = m[2],
    })
  end
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].filetype = "cheatsheet"

  local width = math.min(84, vim.o.columns - 4)
  local height = math.min(#lines, vim.o.lines - 6)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2) - 1,
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " Keymaps ",
    title_pos = "center",
  })
  vim.wo[win].cursorline = true
  vim.wo[win].wrap = false

  local function close()
    if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
  end
  vim.keymap.set("n", "q", close, { buffer = buf, nowait = true })
  vim.keymap.set("n", "<Esc>", close, { buffer = buf, nowait = true })
  vim.api.nvim_create_autocmd("BufLeave", { buffer = buf, once = true, callback = close })
end

vim.api.nvim_create_user_command("Cheatsheet", M.open, { desc = "Show keymap cheatsheet" })

return M
