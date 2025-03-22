local M = {}

M.url = 'https://github.com/saghen/blink.cmp'

M.get = function(c)
  return {
    BlinkCmpDoc = 'NormalFloat',
    BlinkCmpDocBorder = { fg = c.border },
    BlinkCmpDocSeparator = { fg = c.border },
  }
end

return M
