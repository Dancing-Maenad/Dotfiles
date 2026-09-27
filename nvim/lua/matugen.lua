 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#24273a',
    base01 = '#363a4f',
    base02 = '#3e435b',
    base03 = '#6e738d',
    base04 = '#a5adcb',
    base05 = '#cad3f5',
    base06 = '#cad3f5',
    base07 = '#cad3f5',
    base08 = '#ed8796',
    base09 = '#c6a0f6',
    base0A = '#f5bde6',
    base0B = '#b7bdf8',
    base0C = '#b98bf4',
    base0D = '#8b94f4',
    base0E = '#ee90d5',
    base0F = '#f5bde6',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  -- telescope.nvim
  hi('TelescopeNormal',         { fg = '#cad3f5',          bg = '#24273a' })
  hi('TelescopeBorder',         { fg = '#6e738d',             bg = '#24273a' })
  hi('TelescopePromptNormal',   { fg = '#cad3f5',          bg = '#24273a' })
  hi('TelescopePromptBorder',   { fg = '#6e738d',             bg = '#24273a' })
  hi('TelescopePromptPrefix',   { fg = '#b7bdf8',             bg = '#24273a' })
  hi('TelescopePromptCounter',  { fg = '#a5adcb',  bg = '#24273a' })
  hi('TelescopePromptTitle',    { fg = '#24273a',             bg = '#b7bdf8' })
  hi('TelescopePreviewTitle',   { fg = '#24273a',             bg = '#f5bde6' })
  hi('TelescopeResultsTitle',   { fg = '#24273a',             bg = '#c6a0f6' })
  hi('TelescopeSelection',      { fg = '#cad3f5',          bg = '#3e435b' })
  hi('TelescopeSelectionCaret', { fg = '#b7bdf8',             bg = '#3e435b' })
  hi('TelescopeMatching',       { fg = '#b7bdf8',             bold = true })

  -- mini.pick
  hi('MiniPickNormal',         { fg = '#cad3f5',          bg = '#24273a' })
  hi('MiniPickBorder',         { fg = '#6e738d',             bg = '#24273a' })
  hi('MiniPickPrompt',   { fg = '#cad3f5',          bg = '#24273a' })
  hi('MiniPickPromptPrefix',   { fg = '#b7bdf8',             bg = '#24273a' })
  hi('MiniPickBorderText',    { fg = '#24273a',             bg = '#b7bdf8' })
  hi('MiniPickMatchCurrent',      { fg = '#cad3f5',          bg = '#3e435b' })
  hi('MiniPickPromptCaret', { fg = '#b7bdf8',             bg = '#3e435b' })
  hi('MiniPickMatchRanges',       { fg = '#b7bdf8',             bold = true })
end

-- Register a signal handler for SIGUSR1 (matugen updates).
-- The handler re-requires this module, which re-runs the code below, so the
-- previous handle is stopped first; otherwise handlers double on every signal.
if _G.__matugen_signal then
  _G.__matugen_signal:stop()
  _G.__matugen_signal:close()
end

local signal = vim.uv.new_signal()
_G.__matugen_signal = signal
signal:start(
  'sigusr1',
  vim.schedule_wrap(function()
    package.loaded['matugen'] = nil
    require('matugen').setup()
  end)
)

return M
