return {
  {
    'uimataso/uicolors.nvim',
    lazy = false,
    dir = '~/.config/nvim/plugins/uicolors.nvim',
    config = function() vim.cmd.colorscheme('uicolors') end,
  },
}
