return {
  {
    'nvim-telescope/telescope.nvim',
    lazy = false,

    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'nvim-telescope/telescope-ui-select.nvim',
      -- {
      --   'nvim-telescope/telescope-fzf-native.nvim',
      --   build = 'make',
      -- },
    },

    keys = {
      { '=', '<cmd>Telescope find_files<cr>' },
      { 'z=', '<cmd>Telescope spell_suggest<cr>' },

      { '<Leader>ff', '<cmd>Telescope find_files<cr>' },
      { '<Leader>fb', '<cmd>Telescope buffers<cr>' },
      { '<Leader>fs', '<cmd>Telescope live_grep<cr>' },
      -- { '<Leader>fs', mode = 'x' },
      -- { '<Leader>fw' },
      { '<Leader>fr', '<cmd>Telescope resume<cr>' },

      { '<Leader>fd', '<cmd>Telescope diagnostics bufnr=0<cr>' },
      { '<Leader>fD', '<cmd>Telescope diagnostics<cr>' },
      { '<Leader>fw', '<cmd>Telescope diagnostics severity_limit=warning bufnr=0<cr>' },
      { '<Leader>fW', '<cmd>Telescope diagnostics severity_limit=warning<cr>' },

      { '<Leader>fq', '<cmd>Telescope quickfix<cr>' },
      { '<Leader>ft', '<cmd>TodoTelescope<cr>' },

      { '<Leader>gc', '<cmd>Telescope git_commits<cr>' },
      { '<Leader>gb', '<cmd>Telescope git_bcommits<cr>' },
      { '<Leader>gb', mode = 'x', '<cmd>Telescope git_bcommits_range<cr>' },

      { '<Leader>he', '<cmd>Telescope help_tags<cr>' },
      { '<Leader>hl', '<cmd>Telescope highlights<cr>' },
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

      -- { '<C-x><C-p>', mode = 'i', '<cmd>FzfLua complete_path<cr>' },
      -- { '<C-x><C-f>', mode = 'i', '<cmd>FzfLua complete_file<cr>' },
      -- { '<C-x><C-l>', mode = 'i', '<cmd>FzfLua complete_line<cr>' },
    },

    config = function()
      local actions = require('telescope.actions')

      require('telescope').setup({
        extensions = {
          -- fzf = {},
          ['ui-select'] = {
            require('telescope.themes').get_dropdown({}),
          },
        },
      })

      -- require('telescope').load_extension('fzf')
      require('telescope').load_extension('ui-select')

      -- fix the `TelescopePromptNormal` got override by `CursorLine`
      local au = require('utils').au
      local ag = require('utils').ag
      ag('uima/TelescopeCursorLine', function(g)
        au('FileType', {
          group = g,
          pattern = 'TelescopePrompt',
          callback = function()
            vim.opt.cursorline = false
          end,
        })
      end)
    end,
  },

  {
    'ibhagwan/fzf-lua',
    enabled = false,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
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
      grep = {
        formatter = 'path.dirname_first',
      },
      diagnostics = {
        formatter = 'path.dirname_first',
      },
    },

    config = function(_, opts)
      require('fzf-lua').setup(opts)
      require('fzf-lua').register_ui_select()
    end,
  },

  {
    'bassamsdata/namu.nvim',
    lazy = false,

    keys = {
      { '<leader>ss', mode = 'n', ':Namu symbols<cr>', desc = 'Jump to LSP symbol' },
    },

    opts = {
      -- Enable the modules you want
      namu_symbols = {
        enable = true,
        options = {}, -- here you can configure namu
      },

      ui_select = { enable = false }, -- vim.ui.select() wrapper
    },
  },
}
