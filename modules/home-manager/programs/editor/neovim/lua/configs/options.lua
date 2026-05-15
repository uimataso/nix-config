vim.cmd.packadd('uicolors.nvim')
require('uicolors').load()

vim.opt.cursorline = true
vim.opt.scrolloff = 5
vim.opt.winborder = 'rounded'
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.inccommand = 'split'
vim.opt.list = true
vim.opt.listchars = { tab = '▸ ', trail = '·' }
vim.opt.fillchars:append { eob = ' ' }
vim.opt.fillchars:append { diff = '╱' }
vim.opt.smoothscroll = true
vim.opt.conceallevel = 2
vim.opt.nrformats = 'unsigned'

-- 4 spaces as default indent
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.shiftround = true

-- Column --
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 3
vim.opt.signcolumn = 'yes:1'
vim.opt.statuscolumn = '%l%s'

-- Search --
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.pumheight = 10

-- Spell --
vim.opt.spell = false
vim.opt.spellfile = vim.fn.stdpath('data') .. '/spell/en.utf-8.add'
vim.opt.spelllang = 'en_us,cjk'
vim.opt.spelloptions = 'camel'

-- Misc --
vim.opt.shortmess:append('I') -- no intro message
vim.opt.swapfile = false
vim.opt.updatetime = 100
vim.opt.mouse = ''
