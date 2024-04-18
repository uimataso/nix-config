return {
  'nvim-telescope/telescope.nvim',
  lazy = false,
  cmd = { 'Telescope' },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-ui-select.nvim',
  },

  keys = {
    { '=',          function() require('telescope.builtin').find_files() end,           desc = 'Telescope for files' },
    { '<Leader>fe', function() require('telescope.builtin').find_files() end,           desc = 'Telescope for files' },
    { '<Leader>fu', function() require('telescope.builtin').buffers() end,              desc = 'Telescope for buffers' },
    { '<Leader>fs', function() require('telescope.builtin').live_grep() end,            desc = 'Telescope for live_grep' },
    { '<Leader>fr', function() require('telescope.builtin').resume() end,               desc = 'Telescope for resume' },

    { '<Leader>gd', function() require('telescope.builtin').diagnostics() end,          desc = 'Telescope for lsp_diagnostics' },
    { 'gd',         function() require('telescope.builtin').lsp_definitions() end,      desc = 'Telescope for lsp_definitions' },
    { 'gD',         function() require('telescope.builtin').lsp_type_definitions() end, desc = 'Telescope for lsp_type_definitions' },
    { 'gi',         function() require('telescope.builtin').lsp_implementations() end,  desc = 'Telescope for lsp_implementations' },
    { 'gr',         function() require('telescope.builtin').lsp_references() end,       desc = 'Telescope for lsp_references' },
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
        }
      }
    }

    require("telescope").load_extension("ui-select")
  end,
}
