vim.pack.add({
  'https://github.com/stevearc/aerial.nvim',
}, { load = true })

-- require('aerial').setup({
--   on_attach = function(bufnr)
--     -- Jump forwards/backwards with '{' and '}'
--     vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
--     vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
--   end,
-- })

local aerial = require('aerial')

vim.keymap.set('n', 'gro', aerial.fzf_lua_picker, { desc = 'fuzzy code outline' })
vim.keymap.set('n', 'gO', function()
  aerial.toggle({ direction = 'left' })
end, { desc = 'toggle code outline' })
