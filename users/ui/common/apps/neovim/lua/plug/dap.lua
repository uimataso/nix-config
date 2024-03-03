return {
  {
    'mfussenegger/nvim-dap',

    dependencies = {
      { 'theHamsta/nvim-dap-virtual-text', opts = {}, },
      'rcarriga/nvim-dap-ui',
      'jay-babu/mason-nvim-dap.nvim',
    },

    keys = {
      { '<leader>db', function() require('dap').toggle_breakpoint() end,                                    desc = 'Toggle Breakpoint' },
      { '<leader>dB', function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = 'Breakpoint Condition' },
      { '<leader>dc', function() require('dap').continue() end,                                             desc = 'Continue' },
      { '<A-o>',      function() require('dap').step_over() end,                                            desc = 'Step Over' },
      { '<A-i>',      function() require('dap').step_into() end,                                            desc = 'Step Into' },
      { '<A-u>',      function() require('dap').step_out() end,                                             desc = 'Step Out' },
      { '<leader>ds', function() require('dap').session() end,                                              desc = 'Session' },
      { '<leader>dt', function() require('dap').terminate() end,                                            desc = 'Terminate' },
      { '<leader>dw', function() require('dap.ui.widgets').hover() end,                                     desc = 'Widgets' },
      -- { '<leader>da', function() require('dap').continue({ before = get_args }) end, desc = 'Run with Args' },
      -- { '<leader>dC', function() require('dap').run_to_cursor() end,                 desc = 'Run to Cursor' },
      -- { '<leader>dg', function() require('dap').goto_() end,                         desc = 'Go to line (no execute)' },
      -- { '<leader>dj', function() require('dap').down() end,                          desc = 'Down' },
      -- { '<leader>dk', function() require('dap').up() end,                            desc = 'Up' },
      -- { '<leader>dl', function() require('dap').run_last() end,                      desc = 'Run Last' },
      -- { '<leader>dp', function() require('dap').pause() end,                         desc = 'Pause' },
      -- { '<leader>dr', function() require('dap').repl.toggle() end,                   desc = 'Toggle REPL' },
    },

    config = function(_, opts)
      -- setup dap config by VsCode launch.json file
      require('dap.ext.vscode').load_launchjs()
      local dap = require('dap')
      for lang, lang_opts in pairs(opts.configurations) do
        dap.configurations[lang] = lang_opts
      end
    end,
  },

  {
    'rcarriga/nvim-dap-ui',
    keys = {
      { '<leader>du', function() require('dapui').toggle({}) end, desc = 'Dap UI' },
      { '<leader>de', function() require('dapui').eval() end,     desc = 'Eval',  mode = { 'n', 'v' } },
    },
    opts = {},
    config = function(_, opts)
      local dap = require('dap')
      local dapui = require('dapui')

      dapui.setup(opts)

      -- automatically open / close window
      dap.listeners.before.attach.dapui_config = function() dapui.open() end
      dap.listeners.before.launch.dapui_config = function() dapui.open() end
      dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
      dap.listeners.before.event_exited.dapui_config = function() dapui.close() end
    end,
  },

  {
    'jay-babu/mason-nvim-dap.nvim',
    dependencies = {
      'williamboman/mason.nvim',
    },
    cmd = { 'DapInstall', 'DapUninstall' },
    opts = {
      automatic_installation = true,
      handlers = {
        function(config)
          require('mason-nvim-dap').default_setup(config)
        end,
      },
    },
  },
}
