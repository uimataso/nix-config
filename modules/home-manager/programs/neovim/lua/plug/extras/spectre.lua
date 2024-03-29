return {
  'nvim-pack/nvim-spectre',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },

  opts = {
    live_update    = true, -- research when save file
    result_padding = '    ',
    line_sep_start = '',
    line_sep       = '',
  },

  keys = {
    { '<leader>sf', mode = 'n', '<cmd>lua require("spectre").open_file_search()<CR>',                   { desc = "Search on current file" } },
    { '<leader>S',  mode = 'n', '<cmd>lua require("spectre").toggle()<CR>',                             { desc = "Toggle Spectre" } },
    { '<leader>sw', mode = 'n', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>',      { desc = "Search current word" } },
    { '<leader>sw', mode = 'v', '<esc><cmd>lua require("spectre").open_visual()<CR>',                   { desc = "Search current word" } },
    { '<leader>sc', mode = 'n', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', { desc = "Search on current file" } },
  }
}
