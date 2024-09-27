-- TODO: find good markdown tool for linting and formatting
return {
  -- {
  --   'MeanderingProgrammer/markdown.nvim',
  --   name = 'render-markdown',
  --   ft = { 'markdown', },
  --   dependencies = { 'nvim-treesitter/nvim-treesitter' },
  --
  --   opts = {},
  -- }

  {
    'OXY2DEV/markview.nvim',
    ft = 'markdown',

    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },

    opts = {
      -- hybrid_modes = { 'i' },
    },
  },
}
