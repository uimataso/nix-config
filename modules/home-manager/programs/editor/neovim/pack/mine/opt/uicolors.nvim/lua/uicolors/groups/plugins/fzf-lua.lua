local M = {}

M.url = 'https://github.com/ibhagwan/fzf-lua'

M.get = function(c)
  return {
    FzfLuaBorder = 'FloatBorder',
    FzfLuaHeaderBind = { fg = c.syntax.comment },
    FzfLuaHeaderText = { fg = c.syntax.comment },

    FzfLuaPathLineNr = { fg = c.non_text },
    FzfLuaPathColNr = { fg = c.non_text },
    FzfLuaBufLineNr = { fg = c.non_text },
    FzfLuaBufNr = { fg = c.non_text },

    FzfLuaLivePrompt = 'Normal',
    FzfLuaFilePart = { fg = c.misc.file },
  }
end

return M
