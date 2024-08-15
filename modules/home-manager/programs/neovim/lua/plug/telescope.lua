return {
  'nvim-telescope/telescope.nvim',
  lazy = false,

  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-ui-select.nvim',
    'gbrlsnchs/telescope-lsp-handlers.nvim',
  },

  keys = {
    { '=',          function() require('telescope.builtin').find_files() end,  desc = 'Telescope for files' },
    { '<Leader>fe', function() require('telescope.builtin').find_files() end,  desc = 'Telescope for files' },
    { '<Leader>fu', function() require('telescope.builtin').buffers() end,     desc = 'Telescope for buffers' },
    { '<Leader>fs', function() require('telescope.builtin').live_grep() end,   desc = 'Telescope for live_grep' },
    { '<Leader>fr', function() require('telescope.builtin').resume() end,      desc = 'Telescope for resume' },
    { '<Leader>di', function() require('telescope.builtin').diagnostics() end, desc = 'Telescope for diagnostics' },
  },

  config = function()
    local actions = require('telescope.actions')
    require('telescope').setup {
      defaults = {
        mappings = {
          i = {
            ['<esc>'] = actions.close
          },
        },
      },

      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown {}
        },

        -- Use telescope when using lsp command
        ["lsp_handlers"] = {
          require('telescope').load_extension('lsp_handlers')
        },
      }
    }

    require("telescope").load_extension("ui-select")
  end,
}
