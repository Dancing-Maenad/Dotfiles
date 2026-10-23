-- Syntax colouring. Uses the `main` branch (Neovim 0.11+).
-- Needs: a C compiler and the `tree-sitter` CLI (npm i -g tree-sitter-cli, or cargo install tree-sitter-cli).
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install({
        "bash", "c", "cpp", "css", "go", "html", "javascript", "json",
        "lua", "luadoc", "markdown", "markdown_inline", "python", "query", "regex",
        "rust", "toml", "tsx", "typescript", "vim", "vimdoc", "yaml", "dockerfile",
        "diff", "gitcommit", "sql",
      })

      -- Enable highlighting + indentation for any filetype that has a parser
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
        callback = function(ev)
          if pcall(vim.treesitter.start, ev.buf) then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },

  -- Pin the current function/class header at the top of the window
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
    opts = { max_lines = 3 },
  },

  -- Colour matching brackets by nesting depth
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "VeryLazy",
  },
}
