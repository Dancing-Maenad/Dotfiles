return {
  -- Jump anywhere with a couple of keystrokes
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash jump" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash treesitter" },
    },
    opts = {},
  },

  -- Auto-pairs, surround, better text objects, inline colour/TODO highlighting
  {
    "echasnovski/mini.nvim",
    event = "VeryLazy",
    config = function()
      require("mini.pairs").setup()
      require("mini.surround").setup({
        mappings = {
          add = "gsa",
          delete = "gsd",
          find = "gsf",
          find_left = "gsF",
          highlight = "gsh",
          replace = "gsr",
          update_n_lines = "gsn",
        },
      })
      require("mini.ai").setup() -- extra text objects: af/if (function), ac/ic (class), aa/ia (argument)

      local hi = require("mini.hipatterns")
      hi.setup({
        highlighters = {
          fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
          hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
          todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
          note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
          hex_color = hi.gen_highlighter.hex_color(), -- shows #ff8800 in its own colour
        },
      })
    end,
  },

  -- Git signs, hunk actions, blame
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local function map(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
        end
        map("]h", function() gs.nav_hunk("next") end, "Next hunk")
        map("[h", function() gs.nav_hunk("prev") end, "Previous hunk")
        map("<leader>gp", gs.preview_hunk, "Preview hunk")
        map("<leader>gb", gs.blame_line, "Blame line")
        map("<leader>gr", gs.reset_hunk, "Reset hunk")
      end,
    },
  },

  -- Lazygit inside Neovim (requires `lazygit` installed)
  {
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit", "LazyGitCurrentFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = { { "<leader>gg", "<cmd>LazyGit<CR>", desc = "LazyGit" } },
  },

  -- Diagnostics / references panel
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {},
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>",              desc = "Workspace diagnostics" },
      { "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer diagnostics" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<CR>",                   desc = "Quickfix list" },
    },
  },

  -- Floating / split terminal
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = { { "<C-\\>", desc = "Toggle terminal" } },
    opts = { open_mapping = [[<C-\>]], direction = "float" },
  },
}
