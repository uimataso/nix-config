local M = {}

M.get = function(c)
  return {
    -- highlight.on_yank
    Yank = { bg = c.guide, fg = c.black },
  }
end

return M
