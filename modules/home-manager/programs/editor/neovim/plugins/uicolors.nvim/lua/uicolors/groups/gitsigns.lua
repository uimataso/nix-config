local M = {}

M.url = 'https://github.com/lewis6991/gitsigns.nvim'

M.get = function(c)
  return {
    GitSignsAdd = { fg = c.diff.add },
    GitSignsChange = { fg = c.diff.change },
    GitSignsDelete = { fg = c.diff.delete },
  }
end

return M
