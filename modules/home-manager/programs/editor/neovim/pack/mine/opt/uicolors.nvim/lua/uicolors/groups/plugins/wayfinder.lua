local M = {}

M.url = 'https://github.com/error311/wayfinder.nvim'

M.get = function(c)
  return {
    WayfinderPreviewTarget = { bg = c.ui.selection },
  }
end

return M
