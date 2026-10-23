return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = "InsertEnter",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      -- "enter": <CR> accepts, <C-n>/<C-p> or arrows select, <C-e> dismisses
      keymap = { preset = "enter" },
      appearance = { nerd_font_variant = "mono" },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 300 },
        ghost_text = { enabled = true },
      },
      signature = { enabled = true },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
    },
  },
}
