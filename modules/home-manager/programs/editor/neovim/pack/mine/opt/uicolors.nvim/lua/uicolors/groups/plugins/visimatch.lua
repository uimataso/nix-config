local M = {}

M.url = 'https://github.com/wurli/visimatch.nvim'

M.get = function(c)
  return {
    VisiMatch = { bg = c.ui.cursor_line },
  }
end

return M
