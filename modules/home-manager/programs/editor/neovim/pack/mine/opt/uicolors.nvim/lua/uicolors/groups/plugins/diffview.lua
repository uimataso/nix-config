local M = {}

M.url = 'https://github.com/sindrets/diffview.nvim'

M.get = function(c)
  return {
    DiffviewDiffDeleteDim = { fg = c.ui.border },

    diffAdded = { fg = c.diff.add },
    diffRemoved = { fg = c.diff.delete },
    diffChanged = { fg = c.diff.change },
    diffOldFile = { fg = c.blue, bg = c.diff.delete },
    diffNewFile = { fg = c.blue, bg = c.diff.add },
    diffFile = { fg = c.blue },
    diffLine = { fg = c.syntax.comment },
    diffIndexLine = { fg = c.magenta },
  }
end

return M
