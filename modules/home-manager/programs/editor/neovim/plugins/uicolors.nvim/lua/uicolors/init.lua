local M = {}

M.load = function()
  vim.cmd('hi clear')
  vim.g.colors_name = 'uicolors'
  vim.o.termguicolors = true
  vim.o.background = 'dark'

  local colors = require('uicolors.colors')
  local groups = require('uicolors.groups').load(colors)

  for group, hl in pairs(groups) do
    hl = type(hl) == 'string' and { link = hl } or hl
    vim.api.nvim_set_hl(0, group, hl)
  end
end

return M
