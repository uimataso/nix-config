-- Leader key
vim.keymap.set('', '<Space>', '<Nop>')
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

require('options')
require('keymaps')
require('autocmd')
require('plugins')

require('lsp')
require('snippet')
require('status')
require('terminal')
