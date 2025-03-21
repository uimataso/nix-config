vim.keymap.set('n', '<C-n>', '<cmd>cnext<cr>')
vim.keymap.set('n', '<C-p>', '<cmd>cprev<cr>')

local function diagnostic2qflist(diagnostics)
  local qf_list = vim.diagnostic.toqflist(diagnostics)
  vim.fn.setqflist(qf_list, 'r')
  require('quicker').open()
end

vim.keymap.set('n', '<Leader>da', function()
  local diagnostics = vim.diagnostic.get(0, {})
  diagnostic2qflist(diagnostics)
end, { desc = 'add local diagnostics to quickfix' })

vim.keymap.set('n', '<Leader>ds', function()
  local diagnostics = vim.diagnostic.get(0, { severity = { min = vim.diagnostic.severity.WARN } })
  diagnostic2qflist(diagnostics)
end, { desc = 'add local warn/error diagnostics to quickfix' })

vim.keymap.set('n', '<Leader>Da', function()
  local diagnostics = vim.diagnostic.get(nil, {})
  diagnostic2qflist(diagnostics)
end, { desc = 'add all diagnostics to quickfix' })

vim.keymap.set('n', '<Leader>Ds', function()
  local diagnostics = vim.diagnostic.get(nil, { severity = { min = vim.diagnostic.severity.WARN } })
  diagnostic2qflist(diagnostics)
end, { desc = 'add all warn/error diagnostics to quickfix' })

local signs = require('config').signs.diagnostic
local type_icons = {
  E = signs[vim.diagnostic.severity.ERROR] .. ' ',
  W = signs[vim.diagnostic.severity.WARN] .. ' ',
  I = signs[vim.diagnostic.severity.INFO] .. ' ',
  N = ' ',
  H = signs[vim.diagnostic.severity.HINT] .. ' ',
}

return {
  'stevearc/quicker.nvim',
  event = 'FileType qf',

  keys = {
    {
      '<Leader>q',
      mode = { 'n' },
      function() require('quicker').toggle() end,
      desc = 'Toggle quickfik',
    },
    {
      '<Leader>l',
      mode = { 'n' },
      function() require('quicker').toggle({ loclist = true }) end,
      desc = 'Toggle loclist',
    },
  },

  ---@module "quicker"
  ---@type quicker.SetupOptions
  opts = {
    keys = {
      {
        '>',
        function() require('quicker').expand({ before = 2, after = 2, add_to_existing = true }) end,
        desc = 'Expand quickfix context',
      },
      {
        '<',
        function() require('quicker').collapse() end,
        desc = 'Collapse quickfix context',
      },
    },
    type_icons = type_icons,
  },
}
