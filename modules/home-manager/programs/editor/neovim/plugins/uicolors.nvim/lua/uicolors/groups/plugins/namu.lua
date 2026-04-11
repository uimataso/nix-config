local M = {}

M.url = 'https://github.com/bassamsdata/namu.nvim'

M.get = function(c)
  return {
    NamuPrefixSymbol = { fg = c.ui.border },
  }
end

return M
