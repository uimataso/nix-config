return {
  'stevearc/oil.nvim',
  lazy = false,
  cmd = 'Oil',

  keys = {
    {
      '<Leader>o',
      mode = { 'n' },
      function() require('oil').open_float() end,
      desc = 'Open oil browser',
    },

    {
      '-',
      mode = { 'n' },
      function()
        if vim.v.count > 0 then
          vim.api.nvim_feedkeys(vim.v.count .. '-', 'n', false)
        else
          require('oil').open_float()
        end
      end,
      desc = 'Open Oil browser if no count prefix, otherwise do default action',
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
