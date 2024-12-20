local M = {}

M.url = 'https://github.com/ibhagwan/fzf-lua'

M.get = function(c)
  return {
    FzfLuaBorder = 'FloatBorder',
    FzfLuaHeaderBind = { fg = c.green },
    FzfLuaHeaderText = { fg = c.green },
    FzfLuaPathLineNr = { fg = c.green },
    FzfLuaPathColNr = { fg = c.cyan },
  }
end

return M
