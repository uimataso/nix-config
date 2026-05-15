vim.pack.add({
  'https://github.com/nvim-mini/mini.move',
})

require('mini.move').setup({
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
})
