vim.pack.add({
  'https://github.com/nvim-neotest/neotest',
  'https://github.com/nvim-neotest/nvim-nio',
  'https://github.com/antoinemadec/FixCursorHold.nvim',
}, { load = true })

local neotest = require('neotest')

require('neotest').setup({
  adapters = {
    require('rustaceanvim.neotest'),
  },
})

vim.keymap.set('n', '<leader>tt', function()
  neotest.run.run()
end, { desc = 'run the nearest test' })

vim.keymap.set('n', '<leader>tt', function()
  neotest.run.run(vim.fn.expand('%'))
end, { desc = 'run the current file tests' })
