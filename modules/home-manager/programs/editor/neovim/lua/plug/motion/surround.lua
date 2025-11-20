return {
  'kylechui/nvim-surround',
  keys = {
    { 'cs', desc = 'Change the surround' },
    { 'ds', desc = 'Delete the surround' },
    { 'ys', desc = 'Add the surround' },

    { '<leader>s', 'ysiW', desc = 'Add the surround to iW', remap = true },
    { '<leader>ds', 'diwdss', desc = 'Delete prefix and surround', remap = true },
  },
  opts = {
    move_cursor = false,
  },
}
