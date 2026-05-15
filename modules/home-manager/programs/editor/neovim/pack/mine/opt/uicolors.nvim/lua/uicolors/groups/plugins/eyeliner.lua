local M = {}

M.url = 'https://github.com/jinh0/eyeliner.nvim'

M.get = function(c)
  return {
    EyelinerPrimary = { bold = true, underline = true },
    EyelinerSecondary = { underline = true },
  }
end

return M
