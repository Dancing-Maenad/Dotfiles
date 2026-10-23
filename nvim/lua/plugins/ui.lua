return {
  -- Icons (needs a Nerd Font in your terminal)
  {
    "echasnovski/mini.icons",
    lazy = true,
    opts = {},
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "auto",
        globalstatus = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_b = { "branch", "diff" },
        lualine_c = { { "filename", path = 1 }, "diagnostics" },
        lualine_x = { "lsp_status", "filetype" },
      },
    },
  },

  -- Clickable tabs with close buttons
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        mode = "buffers",
        diagnostics = "nvim",
        show_buffer_close_icons = true,
        show_close_icon = false,
        separator_style = "thin",
        offsets = {
          { filetype = "NvimTree", text = "Explorer", text_align = "left", separator = true },
        },
      },
    },
  },

  -- File explorer (single click to select, double click to open)
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle explorer" },
      { "<leader>E", "<cmd>NvimTreeFindFile<CR>", desc = "Reveal current file" },
    },
    opts = {
      view = { width = 32 },
      filters = { dotfiles = false },
      git = { ignore = false },
      renderer = { indent_markers = { enable = true }, highlight_git = "name" },
    },
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      scope = { enabled = true },
      exclude = {
        filetypes = { "alpha", "cheatsheet", "help", "lazy", "mason", "NvimTree", "checkhealth", "man" },
  },
},
  },

  -- Draggable scrollbar with diagnostics/git marks
  { "lewis6991/satellite.nvim", event = "VeryLazy", opts = {} },

  -- Pop-up showing available keybinds
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      delay = 300,
      spec = {
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>c", group = "code" },
        { "<leader>b", group = "buffer" },
        { "<leader>x", group = "trouble" },
        { "<leader>s", group = "symbols" },
      },
    },
  },
}
