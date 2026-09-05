local M = {}

M.url = 'https://codeberg.org/andyg/leap.nvim'

M.get = function(c)
  return {
    LeapLabel = { fg = c.black, bg = c.ui.search },
  }
end

return M
