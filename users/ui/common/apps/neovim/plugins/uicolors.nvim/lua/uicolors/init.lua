local M = {}

M.load = function()

  -- Reset colors
  if vim.g.colors_name then
    vim.cmd('hi clear')
  end

  vim.g.colors_name = 'uicolors'
  vim.o.termguicolors = true
  vim.o.background = 'dark'

  vim.g.skip_ts_default_groups = true

  for name, val in pairs( require 'uicolors.theme' ) do
    vim.api.nvim_set_hl(0, name, val)
  end

end

return M
