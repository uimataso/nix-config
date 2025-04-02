-- disable default ftplugin mapping
vim.g.no_plugin_maps = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 3
vim.opt.signcolumn = 'yes:1'
vim.opt.statuscolumn = '%l%s'
vim.opt.cursorline = true
vim.opt.scrolloff = 5
vim.opt.winborder = 'rounded'
-- vim.opt.conceallevel = 3

-- Search --
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.pumheight = 10
vim.opt.wildignorecase = true
vim.opt.wildignore = { '*.git/*', '*.tags', 'tags', '*.o', '*.class', '*models/*.pt' }
-- vim.opt.suffixesadd = '.md'

-- Special Char --
vim.opt.list = true
vim.opt.listchars = { tab = '▸ ', trail = '·' }
vim.opt.fillchars:append { eob = ' ' }
vim.opt.fillchars:append { diff = '╱' }

-- Split --
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.inccommand = 'split'

-- Spell --
vim.opt.spell = false
vim.opt.spellfile = vim.fn.stdpath('data') .. '/spell/en.utf-8.add'
vim.opt.spelllang = 'en_us,cjk'
vim.opt.spelloptions = 'camel'

-- Fold --
vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldtext = 'v:lua.Foldtext()'
vim.opt.fillchars:append({ fold = ' ' })

-- Msic --
vim.opt.shortmess:append('I') -- no intro message
vim.opt.swapfile = false
vim.opt.updatetime = 100
vim.opt.mouse = ''

function Foldtext()
  local line = require('utils').get_line_with_highlight(0, vim.v.foldstart - 1)
  local lines_count = vim.v.foldend - vim.v.foldstart + 1
  table.insert(line, { ('   󰁂 [ %d ] '):format(lines_count), 'MoreMsg' })
  return line
end
