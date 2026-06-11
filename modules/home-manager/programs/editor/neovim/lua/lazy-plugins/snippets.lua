vim.pack.add({
  'https://github.com/nvim-mini/mini.snippets',
})

local snip_dir = vim.fn.stdpath('config') .. '/snippets'

local gen_loader = require('mini.snippets').gen_loader
require('mini.snippets').setup({
  mappings = {
    expand = '<c-x><c-s>',
  },
  snippets = {
    gen_loader.from_file(snip_dir .. '/all.json'),
    gen_loader.from_lang({
      lang_patterns = {
        bash = { 'shell.json' },
        sh = { 'shell.json' },
      },
    }),
  },
})
