local M = {}

M.url = 'https://github.com/nvim-orgmode/orgmode'

M.get = function(c)
  return {
    ['@org.headline.level1.org'] = '@markup.heading.1',
    ['@org.headline.level2.org'] = '@markup.heading.2',
    ['@org.headline.level3.org'] = '@markup.heading.3',
    ['@org.headline.level4.org'] = '@markup.heading.4',
    ['@org.headline.level5.org'] = '@markup.heading.5',
    ['@org.headline.level6.org'] = '@markup.heading.6',
  }
end

return M
