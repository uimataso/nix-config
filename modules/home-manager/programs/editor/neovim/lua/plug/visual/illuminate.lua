return {
  'RRethy/vim-illuminate',
  event = 'VeryLazy',
  opts = {
    delay = 300,
    under_cursor = false,
  },

  config = function(_, opts)
    require('illuminate').configure(opts)
  end,
}
