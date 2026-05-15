vim.pack.add({
  'https://github.com/lukas-reineke/indent-blankline.nvim',
})

require('ibl').setup({
  scope = {
    show_start = false,
    show_end = false,
  },
})
