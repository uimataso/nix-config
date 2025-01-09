local M = {}

M.url = 'https://github.com/ibhagwan/fzf-lua'

M.get = function(c)
  return {
    FzfLuaBorder = 'FloatBorder',
    FzfLuaHeaderBind = { fg = c.syntax.comment },
    FzfLuaHeaderText = { fg = c.syntax.comment },
    FzfLuaPathLineNr = { fg = c.nontext },
    FzfLuaPathColNr = { fg = c.nontext },
  }
end

return M
