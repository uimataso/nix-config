return {
  'nvim-pack/nvim-spectre',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },

  opts = {
    live_update = true, -- research when save file
    result_padding = '    ',
    line_sep_start = '',
    line_sep = '',
  },

  keys = {
    {
      '<leader>sf',
      mode = 'n',
      '<cmd>lua require("spectre").open_file_search()<cr>',
      { desc = 'Search on current file' },
    },
    {
      '<leader>S',
      mode = 'n',
      '<cmd>lua require("spectre").toggle()<cr>',
      { desc = 'Toggle Spectre' },
    },
    {
      '<leader>sw',
      mode = 'n',
      '<cmd>lua require("spectre").open_visual({select_word=true})<cr>',
      { desc = 'Search current word' },
    },
    {
      '<leader>sw',
      mode = 'v',
      '<esc><cmd>lua require("spectre").open_visual()<cr>',
      { desc = 'Search current word' },
    },
    {
      '<leader>sc',
      mode = 'n',
      '<cmd>lua require("spectre").open_file_search({select_word=true})<cr>',
      { desc = 'Search on current file' },
    },
  },
}
