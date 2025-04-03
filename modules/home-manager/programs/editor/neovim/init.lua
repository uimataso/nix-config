-- Leader key
vim.keymap.set('', '<Space>', '<Nop>')
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

require('config')
require('keymaps')
require('plugins')

require('lsp')
require('treesitter')
require('snippet')
require('status')
require('fold')
require('terminal')
