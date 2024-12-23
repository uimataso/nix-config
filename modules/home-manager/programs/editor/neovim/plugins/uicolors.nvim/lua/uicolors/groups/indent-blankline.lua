local M = {}

M.url = 'https://github.com/lukas-reineke/indent-blankline.nvim'

M.get = function(c)
  return {
    IblIndent = { fg = c.bg_quote },
    IblScope = { fg = c.bg_cursor_line },
  }
end

return M
