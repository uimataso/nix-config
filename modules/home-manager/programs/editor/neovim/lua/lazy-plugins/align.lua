vim.pack.add({
  'https://github.com/Vonr/align.nvim',
})

vim.keymap.set('x', '<leader>aa', function()
  require('align').align_to_char({ length = 1 })
end, { desc = 'align to char' })

vim.keymap.set('x', '<leader>ag', function()
  require('align').align_to_string({ preview = true, regex = true })
end, { desc = 'align to string' })
