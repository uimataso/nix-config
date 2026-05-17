local M = {}

M.url = 'https://github.com/ahkohd/difft.nvim'

M.get = function(c)
  return {
    DifftAdd = { fg = c.diff.add, bg = c:dim(c.diff.add, 0.15) },
    DifftDelete = { fg = c.diff.delete, bg = c:dim(c.diff.delete, 0.15) },
    DifftChange = 'DiffChange',

    DifftFileHeader = 'Title',

    DifftHint = 'String',
  }
end

return M
