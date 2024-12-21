local keymap_dia_to_qf = function(lhs, buf, get_opts)
  vim.keymap.set('n', lhs, function()
    require('utils').get_diagnostic_to_qf(buf, get_opts)
    require('quicker').open()
  end, { desc = 'Add Diagnostics to QuckFix' })
end

vim.keymap.set('n', '<C-n>', '<cmd>cnext<cr>')
vim.keymap.set('n', '<C-p>', '<cmd>cprev<cr>')
keymap_dia_to_qf('<Leader>dwn', nil, {})
keymap_dia_to_qf('<Leader>dln', 0, {})
keymap_dia_to_qf('<Leader>dwe', nil, { severity = { min = vim.diagnostic.severity.ERROR } })
keymap_dia_to_qf('<Leader>dle', 0, { severity = { min = vim.diagnostic.severity.ERROR } })
keymap_dia_to_qf('<Leader>dww', nil, { severity = { min = vim.diagnostic.severity.WARN } })
keymap_dia_to_qf('<Leader>dlw', 0, { severity = { min = vim.diagnostic.severity.WARN } })

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
  },
}
