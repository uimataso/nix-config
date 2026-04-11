local M = {}

M.url = 'https://github.com/OXY2DEV/helpview.nvim'

M.get = function(c)
  return {
    HelpviewCode = { bg = c.markup.raw_bg },
    HelpviewInlineCode = { bg = c.markup.raw_bg },
  }
end

return M
