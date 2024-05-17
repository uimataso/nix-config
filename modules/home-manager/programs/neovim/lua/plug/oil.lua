return {
  'stevearc/oil.nvim',
  lazy = false,
  keys = {
    { '<enter>',    mode = { 'n' }, function() require('oil').open() end,       desc = 'Open oil browser for a directory' },
    { '<Leader>fo', mode = { 'n' }, function() require('oil').open_float() end, desc = 'Open oil browser in a floating window' },
  },
  opts = {
    skip_confirm_for_simple_edits = true,
    view_options = {
      show_hidden = true
    },
    keymaps = {
      ['<BS>'] = 'actions.parent',
    },
    float = {
      win_options = {
        winblend = 0,
      },
    }
  },
}
