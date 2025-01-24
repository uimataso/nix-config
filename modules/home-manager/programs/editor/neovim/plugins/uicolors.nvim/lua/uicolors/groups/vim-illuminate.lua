local M = {}

M.url = 'https://github.com/RRethy/vim-illuminate'

M.get = function(c)
  return {
    IlluminatedWordText = { bg = c.bg_selection },
    IlluminatedWordRead = { bg = c.bg_selection },
    IlluminatedWordWrite = { bg = c.bg_selection },
  }
end

return M
