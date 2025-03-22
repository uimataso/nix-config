local M = {}

M.url = 'https://github.com/wurli/visimatch.nvim'

M.get = function(c)
  return {
    VisiMatch = { bg = c.bg_selection },
  }
end

return M
