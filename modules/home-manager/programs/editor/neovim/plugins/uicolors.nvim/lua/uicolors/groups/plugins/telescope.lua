local M = {}

M.url = 'https://github.com/nvim-telescope/telescope.nvim'

M.get = function(c)
  return {
    TelescopeNormal = 'NormalFloat',
    TelescopeBorder = 'FloatBorder',
    TelescopeMatching = { fg = c.green },
    TelescopeSelection = 'CursorLine',
  }
end

return M
