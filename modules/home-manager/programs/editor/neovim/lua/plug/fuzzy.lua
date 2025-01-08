return {
  {
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    lazy = false,
    command = 'FzfLua',

    keys = {
      { '=', '<cmd>FzfLua files git_icons=false<cr>', desc = 'Find Files' },
      { 'z=', '<cmd>FzfLua spell_suggest<cr>', desc = 'Fzf spell suggest' },

      { '<Leader>ff', '<cmd>FzfLua files<cr>', desc = 'Find Files' },
      { '<Leader>fb', '<cmd>FzfLua buffers<cr>', desc = 'Find Buffer' },
      { '<Leader>fs', '<cmd>FzfLua live_grep<cr>', desc = 'Find by Search' },
      { '<Leader>fs', mode = 'x', '<cmd>FzfLua grep_visual<cr>', desc = 'Find by Search' },
      { '<Leader>fw', '<cmd>FzfLua grep_cword<cr>', desc = 'Find Word' },
      { '<Leader>fW', '<cmd>FzfLua grep_cWORD<cr>', desc = 'Find WORD' },
      { '<Leader>f"', '<cmd>FzfLua registers<cr>', desc = 'Find register' },
      { '<leader>fj', '<cmd>FzfLua jumps<cr>', desc = 'Find Jumplist' },
      { '<leader>fr', '<cmd>FzfLua resume<cr>', desc = 'Find Resume' },

      { '<Leader>fd', '<cmd>FzfLua diagnostics_document<cr>' },
      { '<Leader>fD', '<cmd>FzfLua diagnostics_workspace<cr>' },
      { '<Leader>fee', '<cmd>FzfLua diagnostics_workspace severity_limit=1<cr>' },
      { '<Leader>few', '<cmd>FzfLua diagnostics_workspace severity_limit=2<cr>' },

      { '<Leader>ft', '<cmd>TodoFzfLua<cr>', desc = 'Find Todo' },

      { '<leader>gc', '<cmd>FzfLua git_commits<cr>', desc = 'Git Commits' },
      { '<leader>gs', '<cmd>FzfLua git_status<cr>', desc = 'Git Status' },

      { '<Leader>fh', '<cmd>FzfLua helptags<cr>', desc = 'Find Help' },
      { '<Leader>hl', '<cmd>FzfLua highlights<cr>', desc = 'Find HighLight' },

      { '<C-x><C-p>', mode = 'i', '<cmd>FzfLua complete_path<cr>' },
      { '<C-x><C-f>', mode = 'i', '<cmd>FzfLua complete_file<cr>' },
      { '<C-x><C-l>', mode = 'i', '<cmd>FzfLua complete_line<cr>' },
    },

    opts = {
      -- https://www.reddit.com/r/neovim/comments/1hhiidm/a_few_nice_fzflua_configurations_now_that_lazyvim/
      oldfiles = {
        include_current_session = true,
      },
      previewers = {
        builtin = {
          syntax_limit_b = 1024 * 100, -- 100KB
        },
      },
      grep = {
        rg_glob = true, -- enable glob parsing
        glob_flag = '--iglob', -- case insensitive globs
        glob_separator = '%s%s', -- query separator pattern (lua): ' '
      },
    },

    config = function(_, opts)
      require('fzf-lua').setup(opts)
      require('fzf-lua').register_ui_select()
    end,
  },

  {
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
      {
        '=',
        function()
          require('telescope.builtin').find_files()
        end,
        desc = 'Find Files',
      },
      {
        '<Leader>ff',
        function()
          require('telescope.builtin').find_files()
        end,
        desc = 'Find Files',
      },
      {
        '<Leader>fb',
        function()
          require('telescope.builtin').buffers()
        end,
        desc = 'Find Buffer',
      },
      {
        '<Leader>fs',
        function()
          require('telescope.builtin').live_grep()
        end,
        desc = 'Find by Search',
      },
      { '<Leader>ft', '<cmd>TodoTelescope', desc = 'Find Todo' },
      {
        '<Leader>fd',
        function()
          require('telescope.builtin').diagnostics()
        end,
        desc = 'Find Diagnostic',
      },
      {
        '<Leader>fr',
        function()
          require('telescope.builtin').resume()
        end,
        desc = 'Find Resume',
      },
      {
        '<Leader>fh',
        function()
          require('telescope.builtin').help_tags()
        end,
        desc = 'Find Help',
      },
      {
        '<Leader>gc',
        function()
          require('telescope.builtin').git_commits()
        end,
        desc = 'Git Commit',
      },
      {
        '<Leader>gb',
        function()
          require('telescope.builtin').git_bcommits()
        end,
        desc = 'Git Commit in Buffer',
      },
      {
        '<Leader>gb',
        mode = { 'x' },
        function()
          require('telescope.builtin').git_bcommits_range()
        end,
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
  },
}
