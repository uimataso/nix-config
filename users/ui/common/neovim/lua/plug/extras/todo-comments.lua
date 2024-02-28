return {
  'folke/todo-comments.nvim',
  event = 'VeryLazy',
  dependencies = {
    'nvim-lua/plenary.nvim'
  },

  keys = {
    { '<Leader>ft', '<cmd>TodoTelescope<cr>', desc = 'List all project todos in Tekescope' },
  },
  opts = {},
}
