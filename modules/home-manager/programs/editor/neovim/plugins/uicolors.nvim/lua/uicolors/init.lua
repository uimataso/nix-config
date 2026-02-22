local M = {}

local c = {
  base00 = '#161616', -- 0.0
  base01 = '#201f1d', -- 0.05
  base02 = '#34302b', -- 0.15
  base03 = '#524b40', -- 0.3
  base04 = '#7a6f5c', -- 0.5
  base05 = '#ddc7a1', -- 1.0
  base06 = '#ebdbb2',
  base07 = '#fbf1c7',
  base08 = '#ea6962',
  base09 = '#e78a4e',
  base0A = '#d8a657',
  base0B = '#a9b665',
  base0C = '#89b482',
  base0D = '#7daea3',
  base0E = '#d3869b',
  base0F = '#bd6f3e',
}

local opts = {
  trans_bg = true,
  minimal = true,
}

M.load = function()
  vim.cmd('hi clear')
  vim.g.colors_name = 'uicolors'
  vim.o.termguicolors = true
  vim.o.background = 'dark'

  local colors = require('uicolors.colors').setup(c, opts)
  local groups = require('uicolors.groups').setup(colors)

  for group, hl in pairs(groups) do
    hl = type(hl) == 'string' and { link = hl } or hl
    vim.api.nvim_set_hl(0, group, hl)
  end
end

return M
