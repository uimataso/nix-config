local M = {}

M.url = 'https://github.com/lukas-reineke/indent-blankline.nvim'

M.get = function(c)
  return {
    IblIndent = { fg = c.markup.raw_bg },
    IblScope = { fg = c.ui.cursor_line },
  }
end

return M
