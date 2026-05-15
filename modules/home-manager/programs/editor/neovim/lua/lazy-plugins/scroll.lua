vim.pack.add({
  'https://github.com/karb94/neoscroll.nvim',
})

local neoscroll = require('neoscroll')

neoscroll.setup({
  mappings = {},
  easing = 'sine',
})

--stylua: ignore start
vim.keymap.set('n', '<C-u>', function() neoscroll.ctrl_u({ duration = 150 }) end, { desc = 'Neoscroll <C-u>' })
vim.keymap.set('n', '<C-d>', function() neoscroll.ctrl_d({ duration = 150 }) end, { desc = 'Neoscroll <C-d>' })

vim.keymap.set('n', '<C-b>', function() neoscroll.ctrl_b({ duration = 250 }) end, { desc = 'Neoscroll <C-b>' })
vim.keymap.set('n', '<C-f>', function() neoscroll.ctrl_f({ duration = 250 }) end, { desc = 'Neoscroll <C-f>' })

vim.keymap.set('n', '<C-y>', function() neoscroll.scroll(-0.1, { move_cursor = false, duration = 100 }) end,{ desc = 'Neoscroll <C-y>' })
vim.keymap.set('n', '<C-e>', function() neoscroll.scroll( 0.1, { move_cursor = false, duration = 100 }) end, { desc = 'Neoscroll <C-e>' })

vim.keymap.set('n', 'zt', function() neoscroll.zt({ half_win_duration = 100 }) end, { desc = 'Neoscroll zt' })
vim.keymap.set('n', 'zz', function() neoscroll.zz({ half_win_duration = 100 }) end, { desc = 'Neoscroll zz' })
vim.keymap.set('n', 'zb', function() neoscroll.zb({ half_win_duration = 100 }) end, { desc = 'Neoscroll zb' })
--stylua: ignore end
