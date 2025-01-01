-- disable default ftplugin mapping
vim.g.no_plugin_maps = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes'
vim.opt.cursorline = true
vim.opt.scrolloff = 5
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

-- Msic --
vim.opt.shortmess:append('I') -- no intro message
vim.opt.swapfile = false
vim.opt.updatetime = 100
vim.opt.mouse = ''
