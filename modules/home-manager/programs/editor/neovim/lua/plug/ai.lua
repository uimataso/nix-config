return {
  {
    'nickjvandyke/opencode.nvim',
    version = '*', -- Latest stable release
    dependencies = {
      {
        -- `snacks.nvim` integration is recommended, but optional
        ---@module "snacks" <- Loads `snacks.nvim` types for configuration intellisense
        'folke/snacks.nvim',
        optional = true,
        opts = {
          input = {}, -- Enhances `ask()`
          picker = { -- Enhances `select()`
            actions = {
              opencode_send = function(...)
                return require('opencode').snacks_picker_send(...)
              end,
            },
            win = {
              input = {
                keys = {
                  ['<a-a>'] = { 'opencode_send', mode = { 'n', 'i' } },
                },
              },
            },
          },
        },
      },
    },

    keys = {
      {
        '<Leader>ia',
        mode = { 'n', 'x' },
        function()
          require('opencode').ask('@this: ', { submit = true })
        end,
        desc = 'Ask opencode…',
      },
      {
        '<Leader>ic',
        mode = { 'n', 'x' },
        function()
          require('opencode').select()
        end,
        desc = 'Execute opencode action…',
      },
      {
        '<M-i>',
        mode = { 'n', 't' },
        function()
          require('opencode').toggle()
        end,
        desc = 'Toggle opencode',
      },

      {
        'go',
        mode = { 'n', 'x' },
        function()
          return require('opencode').operator('@this ')
        end,
        desc = 'Add range to opencode',
        expr = true,
      },
      {
        'goo',
        mode = { 'n' },
        function()
          return require('opencode').operator('@this ') .. '_'
        end,
        desc = 'Add line to opencode',
        expr = true,
      },

      {
        '<S-C-u>',
        mode = { 'n' },
        function()
          require('opencode').command('session.half.page.up')
        end,
        desc = 'Scroll opencode up',
      },
      {
        '<S-C-d>',
        mode = { 'n' },
        function()
          require('opencode').command('session.half.page.down')
        end,
        desc = 'Scroll opencode down',
      },
    },

    ---@type opencode.Opts
    -- Your configuration, if any; goto definition on the type or field for details
    opts = {},

    config = function(_, opts)
      vim.g.opencode_opts = opts
      vim.o.autoread = true -- Required for `opts.events.reload`
    end,
  },
}
