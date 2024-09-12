return {
  'stevearc/oil.nvim',
  lazy = false,
  cmd = 'Oil',
  -- event = { 'VimEnter */*,.*', 'BufNew */*,.*' },

  keys = {
    {
      '<Leader>o',
      mode = { 'n' },
      function() require('oil').open_float() end,
      desc = 'Open oil browser in a floating window',
    },
  },

  opts = {
    skip_confirm_for_simple_edits = true,
    view_options = {
      show_hidden = true,
    },
    keymaps = {
      ['<BS>'] = 'actions.parent',
      ['q'] = 'actions.close',
      ['-'] = false,
    },
    float = {
      padding = 5,
      max_width = 80,
      max_height = 0,
      win_options = {
        winblend = 0,
      },
    },
  },
}
