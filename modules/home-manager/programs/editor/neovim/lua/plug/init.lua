vim.cmd('packadd nvim.undotree')
vim.keymap.set('n', '<leader>u', require('undotree').open)

return {
  { import = 'plug.lang' },
  { import = 'plug.misc' },
  { import = 'plug.motion' },
  { import = 'plug.visual' },
  {
    'uimataso/uicolors.nvim',
    lazy = false,
    dir = vim.fn.stdpath('config') .. '/plugins/uicolors.nvim',
    config = function()
      vim.cmd.colorscheme('uicolors')
    end,
  },
}
