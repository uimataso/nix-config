local M = {}

M.url = 'https://github.com/RRethy/vim-illuminate'

M.get = function(c)
  return {
    IlluminatedWordText = { bg = c.ui.cursor_line },
    IlluminatedWordRead = 'IlluminatedWordText',
    IlluminatedWordWrite = 'IlluminatedWordText',
  }
end

return M
