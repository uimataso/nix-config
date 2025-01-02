return {
  {
    'nvim-treesitter/nvim-treesitter',
    event = 'BufReadPost',
    -- build = ':TSUpdate',

    ---@class TSConfig
    opts = {
      highlight = {
        enable = true,
        disable = { 'help' },
      },

      indent = {
        enable = true,
        disable = { 'yaml' },
      },
    },

    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
      vim.opt.runtimepath:append(vim.fn.stdpath('data') .. '/nvim-treesitter')
    end,
  },
}
