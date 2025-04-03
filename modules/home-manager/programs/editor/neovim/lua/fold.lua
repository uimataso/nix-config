vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldtext = 'v:lua.Foldtext()'
vim.opt.fillchars:append({ fold = ' ' })

function Foldtext()
  local line = require('utils').get_line_with_highlight(0, vim.v.foldstart - 1)
  local lines_count = vim.v.foldend - vim.v.foldstart + 1
  table.insert(line, { ('   󰁂 [ %d ] '):format(lines_count), 'MoreMsg' })
  return line
end
