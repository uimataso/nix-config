return {
  {
    'sudo-tee/opencode.nvim',
    lazy = false,

    dependencies = {
      'nvim-lua/plenary.nvim',

      {
        'MeanderingProgrammer/render-markdown.nvim',
        ft = { 'opencode_output' },
        opts = {
          anti_conceal = { enabled = false },
          file_types = { 'opencode_output' },
          heading = {
            icons = {},
          },
          bullet = {
            icons = {},
          },
        },
      },

      'saghen/blink.cmp',

      {
        'folke/snacks.nvim',
        opts = {
          picker = {
            actions = {
              opencode_send = function(picker)
                local selected = picker:selected({ fallback = true })
                if selected and #selected > 0 then
                  local files = {}
                  for _, item in ipairs(selected) do
                    if item.file then
                      table.insert(files, item.file)
                    end
                  end
                  picker:close()

                  require('opencode.core').open({
                    new_session = false,
                    focus = 'input',
                    start_insert = true,
                  })

                  local context = require('opencode.context')
                  for _, file in ipairs(files) do
                    context.add_file(file)
                  end
                end
              end,
            },
            win = {
              input = {
                keys = {
                  -- Use <localleader>o or any preferred key to send files to opencode
                  ['<localleader>o'] = { 'opencode_send', mode = { 'n', 'i' } },
                },
              },
            },
          },
        },
      },
    },

    opts = {
      preferred_picker = 'snacks',
      keymap_prefix = '<leader>i',

      server = {
        url = 'localhost',
        port = 'auto',
      },

      keymap = {
        editor = {
          ['<leader>if'] = { 'toggle_focus' },
        },
        input_window = {
          ['<esc>'] = false,
          ['<S-cr>'] = { 'submit_input_prompt', mode = { 'n', 'i' } },
        },
        output_window = {
          ['<esc>'] = false,
        },
      },
    },
  },

  -- {
  --   'nickjvandyke/opencode.nvim',
  --   version = '*', -- Latest stable release
  --   dependencies = {
  --     {
  --       -- `snacks.nvim` integration is recommended, but optional
  --       ---@module "snacks" <- Loads `snacks.nvim` types for configuration intellisense
  --       'folke/snacks.nvim',
  --       optional = true,
  --       opts = {
  --         input = {}, -- Enhances `ask()`
  --         picker = { -- Enhances `select()`
  --           actions = {
  --             opencode_send = function(...)
  --               return require('opencode').snacks_picker_send(...)
  --             end,
  --           },
  --           win = {
  --             input = {
  --               keys = {
  --                 ['<a-a>'] = { 'opencode_send', mode = { 'n', 'i' } },
  --               },
  --             },
  --           },
  --         },
  --       },
  --     },
  --   },
  --
  --   keys = {
  --     {
  --       '<Leader>ia',
  --       mode = { 'n', 'x' },
  --       function()
  --         require('opencode').ask('@this: ', { submit = true })
  --       end,
  --       desc = 'Ask opencode…',
  --     },
  --     {
  --       '<Leader>ic',
  --       mode = { 'n', 'x' },
  --       function()
  --         require('opencode').select()
  --       end,
  --       desc = 'Execute opencode action…',
  --     },
  --     {
  --       '<M-i>',
  --       mode = { 'n', 't' },
  --       function()
  --         require('opencode').toggle()
  --       end,
  --       desc = 'Toggle opencode',
  --     },
  --
  --     {
  --       'go',
  --       mode = { 'n', 'x' },
  --       function()
  --         return require('opencode').operator('@this ')
  --       end,
  --       desc = 'Add range to opencode',
  --       expr = true,
  --     },
  --     {
  --       'goo',
  --       mode = { 'n' },
  --       function()
  --         return require('opencode').operator('@this ') .. '_'
  --       end,
  --       desc = 'Add line to opencode',
  --       expr = true,
  --     },
  --
  --     {
  --       '<S-C-u>',
  --       mode = { 'n' },
  --       function()
  --         require('opencode').command('session.half.page.up')
  --       end,
  --       desc = 'Scroll opencode up',
  --     },
  --     {
  --       '<S-C-d>',
  --       mode = { 'n' },
  --       function()
  --         require('opencode').command('session.half.page.down')
  --       end,
  --       desc = 'Scroll opencode down',
  --     },
  --   },
  --
  --   ---@type opencode.Opts
  --   -- Your configuration, if any; goto definition on the type or field for details
  --   opts = {},
  --
  --   config = function(_, opts)
  --     vim.g.opencode_opts = opts
  --     vim.o.autoread = true -- Required for `opts.events.reload`
  --   end,
  -- },
}
