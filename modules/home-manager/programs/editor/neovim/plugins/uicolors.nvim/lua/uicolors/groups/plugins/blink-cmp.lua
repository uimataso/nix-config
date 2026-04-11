local M = {}

M.url = 'https://github.com/saghen/blink.cmp'

M.get = function(c)
  return {
    BlinkCmpDoc = 'NormalFloat',
    BlinkCmpDocBorder = { fg = c.ui.border },
    BlinkCmpDocSeparator = { fg = c.ui.border },
  }
end

return M
