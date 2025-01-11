local M = {}

local c = {
  base00 = '#161616', -- 0.0
  base01 = '#3e3932', -- 0.2
  base02 = '#524b40', -- 0.3
  base03 = '#7a6f5c', -- 0.5
  base04 = '#ab9b7e', -- 0.75
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
  trans_bg = false,
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
