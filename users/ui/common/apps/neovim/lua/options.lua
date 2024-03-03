vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes'
vim.opt.cursorline = true
vim.opt.scrolloff = 5
vim.opt.conceallevel = 3

-- Indent --
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.shiftround = true

-- Menu --
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wildignorecase = true
vim.opt.wildignore = { '*.git/*', '*.tags', 'tags', '*.o', '*.class', '*models/*.pt' }
vim.opt.path:append('**')
vim.opt.pumheight = 10
vim.opt.inccommand = 'split'

-- Special Char Visualization --
vim.opt.list = true
vim.opt.listchars = { tab = '▸ ', trail = '·' }
vim.opt.fillchars = 'eob: '

-- Msic --
vim.opt.shortmess:append('I') -- no intro message
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.updatetime = 100
vim.opt.mouse = ''
vim.opt.suffixesadd = '.md'
