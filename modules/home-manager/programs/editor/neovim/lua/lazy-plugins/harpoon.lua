vim.pack.add({
  { src = 'https://github.com/ThePrimeagen/harpoon', version = 'harpoon2' },
}, { load = true })

require('harpoon').setup({})
local harpoon = require('harpoon')

vim.keymap.set('n', '<leader>m', function()
  harpoon:list():add()
end, { desc = 'harpoon add list' })

vim.keymap.set('n', '<leader>l', function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = 'harpoon toggle menu' })

vim.keymap.set('n', '<C-n>', function()
  harpoon:list():next()
end, { desc = 'harpoon next' })

vim.keymap.set('n', '<C-p>', function()
  harpoon:list():prev()
end, { desc = 'harpoon prev' })
