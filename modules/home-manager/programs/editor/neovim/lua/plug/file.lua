local show_column = false

return {
  {
    'stevearc/oil.nvim',
    lazy = false,
    cmd = 'Oil',

    keys = {
      {
        '-',
        mode = { 'n' },
        function()
          if vim.v.count > 0 then
            vim.api.nvim_feedkeys(vim.v.count .. 'k', 'n', false)
          else
            require('oil').open_float(nil, { preview = {} })
          end
        end,
        desc = 'Open Oil browser',
      },
      {
        '<Leader>o',
        mode = { 'n' },
        function()
          require('oil').open(nil, { preview = {} })
        end,
        desc = 'Open Oil in current buffer',
      },
    },

    ---@type oil.SetupOpts
    opts = {
      columns = {},
      win_options = {
        signcolumn = vim.opt.signcolumn:get(),
      },
      skip_confirm_for_simple_edits = true,
      view_options = {
        show_hidden = true,
      },
      keymaps = {
        ['<Esc><Esc>'] = 'actions.close',
        ['q'] = 'actions.close',
        ['-'] = false,
        ['_'] = false,

        ['gd'] = function()
          show_column = not show_column
          if show_column then
            require('oil').set_columns({
              'permissions',
              { 'size', align = 'right', highlight = 'Comment' },
              { 'mtime', format = '<%Y-%m-%d %H:%M>', highlight = 'Comment' },
            })
          else
            require('oil').set_columns({})
          end
        end,
      },
      float = {
        padding = 3,
        max_width = 160,
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

      ag('uima/OilSnacksRename', function(g)
        au('User', {
          group = g,
          pattern = 'OilActionsPost',
          callback = function(event)
            if event.data.actions.type == 'move' then
              Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
            end
          end,
        })
      end)
    end,
  },
}
