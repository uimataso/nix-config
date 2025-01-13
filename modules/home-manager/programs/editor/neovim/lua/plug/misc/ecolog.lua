return {
  'philosofonusus/ecolog.nvim',
  lazy = false,

  keys = {
    { '<leader>ge', '<cmd>EcologGoto<cr>', desc = 'Go to env file' },
    { '<leader>ep', '<cmd>EcologPeek<cr>', desc = 'Ecolog peek variable' },
    { '<leader>es', '<cmd>EcologSelect<cr>', desc = 'Switch env file' },
  },

  opts = {
    integrations = {
      blink_cmp = true,
    },
  },
}
