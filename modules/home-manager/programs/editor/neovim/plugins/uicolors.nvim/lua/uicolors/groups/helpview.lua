local M = {}

M.url = 'https://github.com/OXY2DEV/helpview.nvim'

M.get = function(c)
  return {
    HelpviewCode = { bg = c.bg_float },
    HelpviewInlineCode = { bg = c.bg_float },
  }
end

return M
