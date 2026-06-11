local M = {}

M.url = 'https://github.com/nvim-mini/mini.snippets'

M.get = function(c)
  return {
    MiniSnippetsCurrent = 'NonText',
    MiniSnippetsCurrentReplace = 'NonText',
    MiniSnippetsFinal = 'NonText',
    MiniSnippetsUnvisited = 'NonText',
    MiniSnippetsVisited = 'NonText',
  }
end

return M
