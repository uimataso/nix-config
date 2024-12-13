local M = {}

M.themes = {
  'ui',
  'syntax',
  'plugs',
}

M.load = function()
  -- Reset colors
  if vim.g.colors_name then
    vim.cmd('hi clear')
  end

  vim.g.colors_name = 'uicolors'
  vim.o.termguicolors = true
  vim.o.background = 'dark'

  for _, theme_name in ipairs(M.themes) do
    local theme = require('uicolors.themes.' .. theme_name)
    for name, val in pairs(theme) do
      vim.api.nvim_set_hl(0, name, val)
    end
  end
end

return M
