local M = {}

M.get = function(c)
  return {
    -- test highlight
    Test = { bg = '#00ff00' },
    -- highlight.on_yank
    Yank = { bg = c.ui_text.guide, fg = c.bg },
    -- filler for fold line
    FoldLine = { fg = c.syntax.comment, bold = true },
    FoldFill = { fg = c.ui.fold_fill },
  }
end

return M
