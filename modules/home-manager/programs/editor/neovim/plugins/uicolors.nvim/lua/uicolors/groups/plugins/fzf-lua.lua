local M = {}

M.url = 'https://github.com/ibhagwan/fzf-lua'

M.get = function(c)
  return {
    FzfLuaBorder = 'FloatBorder',
    FzfLuaHeaderBind = { fg = c.syntax.comment },
    FzfLuaHeaderText = { fg = c.syntax.comment },
    FzfLuaPathLineNr = { fg = c.non_text },
    FzfLuaPathColNr = { fg = c.non_text },
  }
end

return M
