vim.keymap.set('', '<Space>', '<Nop>')
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

vim.g.no_plugin_maps = true
-- disable builtin plugins
vim.g.loaded_matchparen = 1
vim.g.loaded_netrw = 1
vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_zip = 1
vim.g.loaded_tar = 1

require('configs.options')
require('configs.autocmd')
require('configs.keymaps')

require('configs.status')
require('configs.fold')
require('configs.find')
require('configs.snippet')
require('configs.project')
require('configs.treesitter')
require('configs.lsp')
require('configs.prompt')

-- only works for .config/nvim/lua
local require_dir = function(dir)
  local full_dir = vim.fn.stdpath('config') .. '/lua/' .. dir
  local files = vim.split(vim.fn.glob(full_dir .. '/*.lua'), '\n')
  for _, file in pairs(files) do
    local name = vim.fn.fnamemodify(file, ':t:r')
    require(dir .. '.' .. name)
  end
end

-- load plugins
require_dir('plugins')

-- lazy load plugins after first scream update
vim.schedule(function()
  require_dir('lazy-plugins')
end)
