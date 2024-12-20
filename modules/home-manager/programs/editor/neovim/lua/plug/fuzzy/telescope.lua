return {
  'nvim-telescope/telescope.nvim',
  lazy = false,
  enabled = false,

  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-ui-select.nvim',
    -- {
    --   'nvim-telescope/telescope-fzf-native.nvim',
    --   build = 'make',
    -- },
  },

  keys = {
    { '=', function() require('telescope.builtin').find_files() end, desc = 'Find Files' },
    { '<Leader>ff', function() require('telescope.builtin').find_files() end, desc = 'Find Files' },
    { '<Leader>fb', function() require('telescope.builtin').buffers() end, desc = 'Find Buffer' },
    { '<Leader>fs', function() require('telescope.builtin').live_grep() end, desc = 'Find by Search' },
    { '<Leader>ft', '<cmd>TodoTelescope', desc = 'Find Todo' },
    { '<Leader>fd', function() require('telescope.builtin').diagnostics() end, desc = 'Find Diagnostic' },
    { '<Leader>fr', function() require('telescope.builtin').resume() end, desc = 'Find Resume' },
    { '<Leader>fh', function() require('telescope.builtin').help_tags() end, desc = 'Find Help' },
    { '<Leader>gc', function() require('telescope.builtin').git_commits() end, desc = 'Git Commit' },
    {
      '<Leader>gb',
      function() require('telescope.builtin').git_bcommits() end,
      desc = 'Git Commit in Buffer',
    },
    {
      '<Leader>gb',
      mode = { 'x' },
      function() require('telescope.builtin').git_bcommits_range() end,
      desc = 'Git Commit in Buffer',
    },
    {
      '<Leader>fp',
      function()
        require('telescope.builtin').find_files({
          prompt_title = 'Lazy Package Files',
          cwd = vim.fs.joinpath(vim.fn.stdpath('data'), 'lazy'),
        })
      end,
      desc = 'Find Package Code',
    },
  },

  config = function()
    local actions = require('telescope.actions')
    require('telescope').setup({
      defaults = {
        mappings = {
          i = {
            ['<esc>'] = actions.close,
          },
        },
      },

      extensions = {
        -- fzf = {},
        -- ['ui-select'] = {
        --   require('telescope.themes').get_dropdown({}),
        -- },
      },
    })

    -- require('telescope').load_extension('fzf')
    -- require('telescope').load_extension('ui-select')
  end,
}
