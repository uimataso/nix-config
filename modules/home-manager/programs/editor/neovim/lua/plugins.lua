local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--single-branch',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

require('lazy').setup({
  { import = 'plug' },
  { import = 'plug.core' },
  { import = 'plug.dev' },
  { import = 'plug.enhance' },
  { import = 'plug.fuzzy' },
  { import = 'plug.lang' },
  { import = 'plug.misc' },
  { import = 'plug.motion' },
  { import = 'plug.visual' },
  {
    'uimataso/uicolors.nvim',
    lazy = false,
    dir = vim.fn.stdpath('config') .. '/plugins/uicolors.nvim',
    config = function() vim.cmd.colorscheme('uicolors') end,
  },
}, {
  defaults = { lazy = true },
  lockfile = vim.fn.stdpath('data') .. '/lazy-lock.json', -- for nix
  install = { colorscheme = { 'uicolors' } },
  change_detection = { notify = false },
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'matchit',
        'matchparen',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
})

vim.keymap.set('n', '<Leader>zz', '<cmd>Lazy<cr>')
