return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
    },

    keys = {
      { '<Leader>tt', function() require('neotest').run.run(vim.fn.expand('%')) end,                      desc = 'Run current file\'s test' },
      { '<leader>tT', function() require('neotest').run.run(vim.loop.cwd()) end,                          desc = 'Run all test files' },
      { '<Leader>tr', function() require('neotest').run.run() end,                                        desc = 'Run the nearest test' },
      { '<leader>to', function() require('neotest').output.open({ enter = true, auto_close = true }) end, desc = 'Show test output' },
      { '<leader>tO', function() require('neotest').output_panel.toggle() end,                            desc = 'Toggle output panel' },
      { '<Leader>ts', function() require('neotest').summary.toggle() end,                                 desc = 'Toggle test summary' },
      { '<leader>tS', function() require('neotest').run.stop() end,                                       desc = 'Stop test' },
    },

    opts = {
      adapters = {},
      status = {
        virtual_text = true,
        signs = false,
      },
    },

    config = function(_, opts)
      require('neotest').setup(opts)
    end
  },

  {
    'mfussenegger/nvim-dap',
    keys = {
      { '<leader>td', function() require('neotest').run.run({ strategy = 'dap' }) end, desc = 'Debug Nearest test' },
    },
  },
}
