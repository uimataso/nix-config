return {
  {
    'A7Lavinraj/fyler.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    lazy = false,

    cmd = 'Fyler',
    keys = {
      {
        '-',
        mode = { 'n' },
        function()
          if vim.v.count > 0 then
            vim.api.nvim_feedkeys(vim.v.count .. 'k', 'n', false)
          else
            require('fyler').open({ kind = 'float' })
          end
        end,
        desc = 'Open Fyler browser',
      },
    },

    opts = {
      views = {
        finder = {
          mappings = {
            ['-'] = function(self)
              vim.api.nvim_feedkeys(vim.v.count .. 'k', 'n', false)
            end,
          },
        },
      },
      integrations = {
        icon = 'nvim_web_devicons',
      },
    },
  },
}
