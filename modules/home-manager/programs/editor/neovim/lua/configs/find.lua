vim.opt.wildignorecase = true
vim.opt.wildignore = { '*.git/*', '*.tags', 'tags', '*.o', '*.class', '*models/*.pt' }
-- vim.opt.path:append('**')
-- vim.opt.suffixesadd = '.md'
vim.o.findfunc = 'v:lua.Findfunc'

local cabbrev = require('uima').cabbrev
cabbrev('f', 'find')

-- from: https://www.reddit.com/r/neovim/comments/1t86svd/how_to_make_find_fast

local fdfunc

if vim.fn.executable('fd') == 1 then
  fdfunc = 'fd'
else
  vim.notify('fd not found on system. :find will not use fd', vim.log.levels.WARN)
  vim.opt.path:append { '**' }
  return
end

function Findfunc(cmdarg, _)
  local param = vim.fn.getcwd() .. '.*' .. tostring(cmdarg)
  local fdout = vim
    .system({ fdfunc, '--type', 'f', '--hidden', '--exclude', '.git', '--full-path', param })
    :wait()
  local matches = vim.split(fdout.stdout, '\n', { trimempty = true })
  return matches
end
