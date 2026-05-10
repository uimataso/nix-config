return {
  'nvim-mini/mini.move',
  version = '*',

  keys = {
    { '<c-h>', mode = { 'x' } },
    { '<c-l>', mode = { 'x' } },
    { '<c-j>', mode = { 'x' } },
    { '<c-k>', mode = { 'x' } },
  },

  opts = {
    mappings = {
      left = '<c-h>',
      right = '<c-l>',
      down = '<c-j>',
      up = '<c-k>',

      -- No enable for normal mode
      line_left = '',
      line_right = '',
      line_down = '',
      line_up = '',
    },
  },
}
