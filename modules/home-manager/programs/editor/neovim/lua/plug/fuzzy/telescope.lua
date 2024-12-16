return {
  'nvim-telescope/telescope.nvim',
  lazy = false,

  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-ui-select.nvim',
    -- {
    --   'nvim-telescope/telescope-fzf-native.nvim',
    --   build = 'make',
    -- },
  },

  keys = {
    { '=', function() require('telescope.builtin').find_files() end, desc = 'Telescope find files' },
    { '<Leader>fe', function() require('telescope.builtin').find_files() end, desc = 'Telescope find files' },
    { '<Leader>fu', function() require('telescope.builtin').buffers() end, desc = 'Telescope find buffers' },
    { '<Leader>fs', function() require('telescope.builtin').live_grep() end, desc = 'Telescope live grep' },
    { '<Leader>fr', function() require('telescope.builtin').resume() end, desc = 'Telescope resume last search' },
    { '<Leader>fh', function() require('telescope.builtin').help_tags() end, desc = 'Telescope search help' },
    { '<Leader>di', function() require('telescope.builtin').diagnostics() end, desc = 'Telescope diagnostics list' },
    {
      '<Leader>do',
      function() require('telescope.builtin').diagnostics({ bufnr = 0 }) end,
      desc = 'Telescope diagnostics list in this buffer',
    },
    { '<Leader>gc', function() require('telescope.builtin').git_commits() end, desc = 'Telescope git commits list' },
    {
      '<Leader>gb',
      function() require('telescope.builtin').git_bcommits() end,
      desc = 'Telescope git commits list for this buffer',
    },
    {
      '<Leader>gb',
      mode = { 'x' },
      function() require('telescope.builtin').git_bcommits_range() end,
      desc = 'Telescope git commits list for this buffer',
    },
    {
      '<Leader>fp',
      function()
        require('telescope.builtin').find_files({
          prompt_title = 'Lazy Package Files',
          cwd = vim.fs.joinpath(vim.fn.stdpath('data'), 'lazy'),
        })
      end,
      desc = 'Telescope search help',
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
        ['ui-select'] = {
          require('telescope.themes').get_dropdown({}),
        },
      },
    })

    -- require('telescope').load_extension('fzf')
    require('telescope').load_extension('ui-select')
  end,
}
