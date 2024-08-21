return {
  'stevearc/qf_helper.nvim',
  enabled = false,
  event = 'QuickFixCmdPre',
  opts = {},
  keys = {
    { '<C-j>', '<cmd>QNext<cr>' },
    { '<C-k>', '<cmd>QPrev<cr>' },
    { '<leader>q', '<cmd>QFToggle!<cr>' },
    { '<leader>l', '<cmd>LLToggle!<cr>' },
  },
}
