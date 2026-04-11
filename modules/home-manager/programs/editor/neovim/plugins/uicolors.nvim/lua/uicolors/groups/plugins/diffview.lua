local M = {}

M.url = 'https://github.com/sindrets/diffview.nvim'

M.get = function(c)
  return {
    DiffviewDiffDeleteDim = { fg = c.ui.border },
  }
end

return M
