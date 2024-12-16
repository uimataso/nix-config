local M = {}

M.get = function(c)
  return {
    -- highlight.on_yank
    Yank = { bg = c.green, fg = c.black },
  }
end

return M
