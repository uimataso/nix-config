return {
  'stevearc/qf_helper.nvim',
  enabled = false,
  event = 'QuickFixCmdPre',
  opts = {},
  keys = {
    { '<C-j>',     ':QNext<cr>' },
    { '<C-k>',     ':QPrev<cr>' },
    { '<leader>q', ':QFToggle!<cr>' },
    { '<leader>l', ':LLToggle!<cr>' },
  },
}
