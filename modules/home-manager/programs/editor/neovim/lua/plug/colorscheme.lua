return {
  {
    'uimataso/uicolors.nvim',
    -- enabled = false,
    lazy = false,
    dir = '~/.config/nvim/plugins/uicolors.nvim',
    config = function() vim.cmd.colorscheme('uicolors') end,
  },
}
