-- Placeholder: replace with your own colourscheme plugin + setup.
-- Example:
-- return {
--   "catppuccin/nvim", name = "catppuccin", priority = 1000,
--   config = function() vim.cmd.colorscheme("catppuccin") end,
-- }
return {
  {
    "nvim-lua/plenary.nvim", -- harmless shared dependency; keeps this file a valid spec
    lazy = true,
    init = function()
      pcall(vim.cmd.colorscheme, "habamax")
    end,
  },
}
