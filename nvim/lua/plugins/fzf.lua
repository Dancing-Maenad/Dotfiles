return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "echasnovski/mini.icons" },
    cmd = "FzfLua",
    keys = {
      { "<leader>ff", "<cmd>FzfLua files<CR>", desc = "Find files" },
      { "<leader>fg", "<cmd>FzfLua live_grep<CR>", desc = "Live grep" },
      { "<leader>fw", "<cmd>FzfLua grep_cword<CR>", desc = "Grep word under cursor" },
      { "<leader>fb", "<cmd>FzfLua buffers<CR>", desc = "Buffers" },
      { "<leader>fr", "<cmd>FzfLua oldfiles<CR>", desc = "Recent files" },
      { "<leader>fh", "<cmd>FzfLua helptags<CR>", desc = "Help tags" },
      { "<leader>fk", "<cmd>FzfLua keymaps<CR>", desc = "Keymaps" },
      { "<leader>fd", "<cmd>FzfLua diagnostics_document<CR>", desc = "Diagnostics" },
      { "<leader>fc", "<cmd>FzfLua commands<CR>", desc = "Commands" },
      { "<leader>/", "<cmd>FzfLua lgrep_curbuf<CR>", desc = "Search in buffer" },
      { "<leader>gc", "<cmd>FzfLua git_commits<CR>", desc = "Git commits" },
      { "<leader>gs", "<cmd>FzfLua git_status<CR>", desc = "Git status" },
    },
    opts = {
      "default-title",
      winopts = {
        preview = { layout = "flex", flip_columns = 120 },
      },
    },
    config = function(_, opts)
      local fzf = require("fzf-lua")
      fzf.setup(opts)
      fzf.register_ui_select() -- use fzf for vim.ui.select (code actions, etc.)
    end,
  },
}
