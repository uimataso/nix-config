vim.pack.add({
  'https://github.com/smjonas/inc-rename.nvim',
}, { load = true })

require('inc_rename').setup({})

vim.keymap.set('n', 'grn', function()
  return ':IncRename ' .. vim.fn.expand('<cword>')
end, { expr = true, desc = 'lsp rename' })
