return {
  'karb94/neoscroll.nvim',
  opts = {
    mappings = {},
  },
  keys = {
    { '<C-u>',      function() require('neoscroll').scroll(-vim.wo.scroll, true, 150) end,                  desc = 'Neoscroll <C-u>' },
    { '<C-d>',      function() require('neoscroll').scroll(vim.wo.scroll, true, 150) end,                   desc = 'Neoscroll <C-d>' },
    { '<C-b>',      function() require('neoscroll').scroll(-vim.api.nvim_win_get_height(0), true, 250) end, desc = 'Neoscroll <C-b>' },
    { '<C-f>',      function() require('neoscroll').scroll(vim.api.nvim_win_get_height(0), true, 250) end,  desc = 'Neoscroll <C-f>' },
    { '<C-y>',      function() require('neoscroll').scroll(-0.10, false, 50) end,                           desc = 'Neoscroll <C-y>' },
    { '<C-e>',      function() require('neoscroll').scroll(0.10, false, 50) end,                            desc = 'Neoscroll <C-e>' },
    { 'zt',         function() require('neoscroll').zt(100) end,                                            desc = 'Neoscroll zt' },
    { 'zz',         function() require('neoscroll').zz(100) end,                                            desc = 'Neoscroll zz' },
    { 'zb',         function() require('neoscroll').zb(100) end,                                            desc = 'Neoscroll zb' },

    { '<PageUp>',   function() require('neoscroll').scroll(-vim.wo.scroll, true, 150) end,                  desc = 'Neoscroll <C-u>' },
    { '<PageDown>', function() require('neoscroll').scroll(vim.wo.scroll, true, 150) end,                   desc = 'Neoscroll <C-d>' },
  }
}
