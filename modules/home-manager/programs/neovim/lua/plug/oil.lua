return {
  'stevearc/oil.nvim',
  lazy = false,
  keys = {
    {
      '<Leader>o',
      mode = { 'n' },
      function()
        require('oil').open_float()
      end,
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
    },
    float = {
      win_options = {
        winblend = 0,
      },
    },
  },
}
