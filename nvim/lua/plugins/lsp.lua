return {
  { "mason-org/mason.nvim", cmd = "Mason",       opts = {} },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "saghen/blink.cmp",
      "j-hui/fidget.nvim",
    },
    config = function()
      -- Share completion capabilities with every server
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      })

      -- Installs servers via Mason and enables them automatically
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "bashls", "jsonls", "yamlls", "pyright", "ts_ls", "taplo" },
        automatic_enable = true,
      })

      vim.diagnostic.config({
        severity_sort = true,
        virtual_text = { spacing = 2, prefix = "●" },
        float = { border = "rounded" },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
          },
        },
      })

      -- Neovim 0.11 already provides: grn rename, gra code action, grr references,
      -- gri implementation, grt type definition, gO symbols, K hover.
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp_attach", { clear = true }),
        callback = function(ev)
          local fzf = require("fzf-lua")
          local function map(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
          end
          map("gd", fzf.lsp_definitions, "Go to definition")
          map("gD", vim.lsp.buf.declaration, "Go to declaration")
          map("gr", fzf.lsp_references, "References")
          map("<leader>ss", fzf.lsp_document_symbols, "Document symbols")
          map("<leader>sS", fzf.lsp_workspace_symbols, "Workspace symbols")
          map("<leader>rn", vim.lsp.buf.rename, "Rename")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
        end,
      })
    end,
  },

  -- LSP progress spinner
  { "j-hui/fidget.nvim",    event = "LspAttach", opts = {} },

  -- Neovim API knowledge for lua_ls (only loads for Lua files)
  { "folke/lazydev.nvim",   ft = "lua",          opts = {} },
}
