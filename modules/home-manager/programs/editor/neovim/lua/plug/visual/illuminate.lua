return {
  'RRethy/vim-illuminate',
  event = 'VeryLazy',
  opts = {
    delay = 300,
    under_cursor = false,

    disable_keymaps = true,
  },

  config = function(_, opts)
    require('illuminate').configure(opts)
  end,
}
