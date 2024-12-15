local M = {}

M.get = function(c)
  return {
    Yank = { bg = c.green, fg = c.black },
  }
end

return M
