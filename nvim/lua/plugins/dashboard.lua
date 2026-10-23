return {
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "echasnovski/mini.icons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      dashboard.section.header.val = {
        " ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
        " ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
        " ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
        " ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
        " ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
        " ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
      }

      dashboard.section.buttons.val = {
        dashboard.button("f", "  Find file", "<cmd>FzfLua files<CR>"),
        dashboard.button("r", "  Recent files", "<cmd>FzfLua oldfiles<CR>"),
        dashboard.button("g", "  Live grep", "<cmd>FzfLua live_grep<CR>"),
        dashboard.button("e", "  New file", "<cmd>ene | startinsert<CR>"),
        dashboard.button("c", "  Cheatsheet", "<cmd>Cheatsheet<CR>"),
        dashboard.button(
          "n", "  Neovim config",
          "<cmd>lua require('fzf-lua').files({ cwd = vim.fn.stdpath('config') })<CR>"
        ),
        dashboard.button("l", "󰒲  Plugins", "<cmd>Lazy<CR>"),
        dashboard.button("m", "  Mason", "<cmd>Mason<CR>"),
        dashboard.button("q", "  Quit", "<cmd>qa<CR>"),
      }

      alpha.setup(dashboard.config)

      -- Footer: plugin count + startup time, filled in once lazy.nvim finishes
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        once = true,
        callback = function()
          local stats = require("lazy").stats()
          local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
          dashboard.section.footer.val =
            ("⚡ %d/%d plugins loaded in %sms"):format(stats.loaded, stats.count, ms)
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },
}
