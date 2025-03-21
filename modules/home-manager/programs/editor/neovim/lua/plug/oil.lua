return {
  'stevearc/oil.nvim',
  lazy = false,
  cmd = 'Oil',

  keys = {
    {
      '<Leader>o',
      mode = { 'n' },
      function() require('oil').open_float() end,
      desc = 'Open Oil browser',
    },

    {
      '-',
      mode = { 'n' },
      function()
        if vim.v.count > 0 then
          vim.api.nvim_feedkeys(vim.v.count .. 'k', 'n', false)
        else
          require('oil').open_float()
        end
      end,
      desc = 'Open Oil browser',
    },
  },

  ---@type oil.SetupOpts
  opts = {
    skip_confirm_for_simple_edits = true,
    view_options = {
      show_hidden = true,
    },
    keymaps = {
      ['<Esc><Esc>'] = 'actions.close',
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

  config = function(_, opts)
    require('oil').setup(opts)

    local au = require('utils').au
    local ag = require('utils').ag

    ag('uima/OilSettings', function(g)
      au('FileType', {
        group = g,
        pattern = 'oil',
        callback = function()
          vim.keymap.set('n', '<BS>', '<Nop>', { buffer = 0 })
          vim.keymap.set('n', '-', 'k', { buffer = 0 })
        end,
      })
    end)
  end,
}
