local M = {}

M.get = function(c)
  return {
    -- test highlight
    Test = { bg = '#00ff00' },
    -- highlight.on_yank
    Yank = { bg = c.ui_text.guide, fg = c.bg },
  }
end

return M
