local M = {}

M.url = 'https://github.com/RRethy/vim-illuminate'

M.get = function(c)
  return {
    IlluminatedWordText = { bg = c.bg_selection },
    IlluminatedWordRead = 'IlluminatedWordText',
    IlluminatedWordWrite = 'IlluminatedWordText',
  }
end

return M
