vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.Foldexpr()'
vim.opt.foldtext = 'v:lua.Foldtext()'
vim.opt.fillchars:append({ fold = ' ' })

function Foldexpr()
  return vim.treesitter.foldexpr()
end

function Foldtext()
  local line = vim.api.nvim_buf_get_lines(0, vim.v.foldstart - 1, vim.v.foldstart, false)[1]
  local lines_count = vim.v.foldend - vim.v.foldstart + 1

  local suffix = ('  󰁂 [ %d ]  '):format(lines_count)

  local win_width = vim.api.nvim_win_get_width(0)
  local used_width = vim.fn.strdisplaywidth(line) + vim.fn.strdisplaywidth(suffix)
  local fill = string.rep('─', math.max(win_width - used_width - 2, 0))

  return {
    { line, 'FoldLine' },
    { suffix, 'MoreMsg' },
    { fill, 'FoldFill' },
  }
end
