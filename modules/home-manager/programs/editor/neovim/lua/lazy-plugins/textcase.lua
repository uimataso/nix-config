vim.pack.add({
  'https://github.com/johmsalas/text-case.nvim',
})

-- TODO: use fuzzyfinder with preview instead
require('textcase').setup({
  prefix = '<leader>c',
})
