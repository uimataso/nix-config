return {
  'akinsho/toggleterm.nvim',
  keys = {
    { '<C-t>',      desc = 'Toggle terminal' },
    { '<Leader>th', '<cmd>ToggleTerm size=10 direction=horizontal<cr>',        desc = 'Open terminal in a horizontal window' },
    { '<Leader>tf', '<cmd>ToggleTerm direction=float<cr>',                     desc = 'Open terminal in a floating window' },

    { '<Leader>te', '<cmd>TermExec cmd="!!"<cr>',                              desc = 'Exec previous command' },
    { '<Leader>tp', '<cmd>TermExec cmd="run -i run.py"<cr>',                   desc = 'run run.py, use in ipy' },

    { '<leader>tc', '<cmd>execute v:count1.\'TermExec cmd="<C-v><C-c>"\'<CR>', desc = 'Send <C-c> to terminal' },
  },

  opts = {
    size = 20,
    open_mapping = [[<c-t>]],
    direction = 'float',
    highlights = {
      Normal = {
        link = 'Normal',
      },
      NormalFloat = {
        link = 'NormalFloat'
      },
      FloatBorder = {
        link = 'FloatBorder',
      },
    },
  }
}
