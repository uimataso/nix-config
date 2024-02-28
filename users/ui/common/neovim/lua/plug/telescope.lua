return {
  'nvim-telescope/telescope.nvim',
  cmd = { 'Telescope' },
  dependencies = {
    'nvim-lua/plenary.nvim'
  },

  keys = {
    { '<Leader>fe', function() require('telescope.builtin').find_files() end,           desc = 'Telescope for files' },
    { ';',          function() require('telescope.builtin').find_files() end,           desc = 'Telescope for files' },
    { '<Leader>fb', function() require('telescope.builtin').buffers() end,              desc = 'Telescope for buffers' },
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
      }
    }
  end,
}
