local M = {}

M.get = function(c)
  return {
    -- test highlight
    Test = { bg = '#00ff00' },
    -- highlight.on_yank
    Yank = { bg = c.guide, fg = c.black },
  }
end

return M
