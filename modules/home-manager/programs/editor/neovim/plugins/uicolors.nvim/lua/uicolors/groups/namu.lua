local M = {}

M.url = 'https://github.com/bassamsdata/namu.nvim'

M.get = function(c)
  return {
    NamuPrefixSymbol = { fg = c.border },
  }
end

return M
