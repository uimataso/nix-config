return {
  {
    'nvim-treesitter/nvim-treesitter',
    event = 'BufReadPost',
    -- build = ':TSUpdate',

    opts = {
      highlight = {
        enable = true,
        disable = { 'help' },
      },

      indent = {
        enable = true,
        disable = { 'yaml' },
      },

      playground = {
        enable = true,
      },

      query_linter = {
        enable = true,
        -- use_virtual_text = true,
        -- lint_events = { 'BufWrite', 'CursorHold' },
      },
    },

    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
      vim.opt.runtimepath:append(vim.fn.stdpath('data') .. '/nvim-treesitter')
    end,
  },
}
