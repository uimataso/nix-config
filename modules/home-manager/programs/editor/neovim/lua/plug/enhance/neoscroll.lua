return {
  'karb94/neoscroll.nvim',

  keys = {
    { '<C-u>', function() require('neoscroll').ctrl_u({ duration = 150 }) end, desc = 'Neoscroll <C-u>' },
    { '<C-d>', function() require('neoscroll').ctrl_d({ duration = 150 }) end, desc = 'Neoscroll <C-d>' },

    { '<C-b>', function() require('neoscroll').ctrl_b({ duration = 250 }) end, desc = 'Neoscroll <C-b>' },
    { '<C-f>', function() require('neoscroll').ctrl_f({ duration = 250 }) end, desc = 'Neoscroll <C-f>' },

    {
      '<C-y>',
      function() require('neoscroll').scroll(-0.1, { move_cursor = false, duration = 100 }) end,
      desc = 'Neoscroll <C-y>',
    },
    {
      '<C-e>',
      function() require('neoscroll').scroll(0.1, { move_cursor = false, duration = 100 }) end,
      desc = 'Neoscroll <C-e>',
    },

    { 'zt', function() require('neoscroll').zt({ half_win_duration = 100 }) end, desc = 'Neoscroll zt' },
    { 'zz', function() require('neoscroll').zz({ half_win_duration = 100 }) end, desc = 'Neoscroll zz' },
    { 'zb', function() require('neoscroll').zb({ half_win_duration = 100 }) end, desc = 'Neoscroll zb' },

    { '<PageUp>', '<C-u>', remap = true },
    { '<PageDown>', '<C-d>', remap = true },
  },

  opts = {
    mappings = {},
    easing = 'sine',
  },
}
