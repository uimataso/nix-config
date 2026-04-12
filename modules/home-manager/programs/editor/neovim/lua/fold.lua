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
  return {
    { line, 'Normal' },
    { ('   󰁂 [ %d ] '):format(lines_count), 'MoreMsg' },
  }
end
