local M = {}

M.url = 'https://github.com/folke/snacks.nvim'

M.get = function(c)
  return {
    SnacksPickerCursorLine = 'Normal',
    SnacksPickerMatch = 'MatchParen',
  }
end

return M
