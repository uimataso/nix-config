vim.cmd.packadd('uicolors.nvim')
require('uicolors').load()

vim.opt.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.numberwidth = 3
vim.opt.signcolumn = 'yes:1'
vim.opt.statuscolumn = '%l%s'
