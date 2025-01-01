-- vim.keymap.set('n', '<C-n>', '<cmd>cnext<cr>')
-- vim.keymap.set('n', '<C-p>', '<cmd>cprev<cr>')
vim.keymap.set('n', '<C-n>', '<cmd>lnext<cr>')
vim.keymap.set('n', '<C-p>', '<cmd>lprev<cr>')

vim.keymap.set('n', '<Leader>da', function()
  local diagnostics = vim.diagnostic.get(nil, {})
  local qf_list = vim.diagnostic.toqflist(diagnostics)
  vim.fn.setqflist(qf_list, 'r')
  require('quicker').open()
end, { desc = 'add diagnostic to quickfix' })

vim.keymap.set('n', '<Leader>dl', function()
  local diagnostics = vim.diagnostic.get(0, {})
  local qf_list = vim.diagnostic.toqflist(diagnostics)
  vim.fn.setloclist(0, qf_list, 'r')
  require('quicker').open({ loclist = true })
end, { desc = 'add diagnostic to quickfix' })

return {
  'stevearc/quicker.nvim',
  event = 'FileType qf',

  keys = {
    {
      '<Leader>q',
      mode = { 'n' },
      function()
        require('quicker').toggle()
      end,
      desc = 'Toggle quickfik',
    },
    {
      '<Leader>l',
      mode = { 'n' },
      function()
        require('quicker').toggle({ loclist = true })
      end,
      desc = 'Toggle loclist',
    },
  },

  ---@module "quicker"
  ---@type quicker.SetupOptions
  opts = {
    keys = {
      {
        '>',
        function()
          require('quicker').expand({ before = 2, after = 2, add_to_existing = true })
        end,
        desc = 'Expand quickfix context',
      },
      {
        '<',
        function()
          require('quicker').collapse()
        end,
        desc = 'Collapse quickfix context',
      },
    },
    type_icons = {
      E = '󰅚 ',
      W = '󰀪 ',
      I = ' ',
      N = ' ',
      H = ' ',
    },
  },
}
