return {
  {
    'ggandor/leap.nvim',
    dependencies = {
      'ggandor/leap.nvim',
      'tpope/vim-repeat',
    },
    keys = {
      { 's', mode = { 'n', 'x', 'o' }, '<Plug>(leap-forward-to)', desc = 'Leap forward to' },
      { 'S', mode = { 'n', 'x', 'o' }, '<Plug>(leap-backward-to)', desc = 'Leap backward to' },
      { 'x', mode = { 'x', 'o' }, '<Plug>(leap-forward-till)', desc = 'Leap forward till' },
      { 'X', mode = { 'x', 'o' }, '<Plug>(leap-backward-till)', desc = 'Leap backward till' },
      { 'gs', mode = { 'n', 'x', 'o' }, '<Plug>(leap-from-window)', desc = 'Leap from window' },
      { 'gs', mode = { 'n', 'x', 'o' }, '<Plug>(leap-cross-window)', desc = 'Leap from window' },
      { 'gr', mode = { 'n', 'o' }, function() require('leap.remote').action() end, desc = 'Leap remot' },
      {
        'ga',
        mode = { 'n', 'x', 'o' },
        function() require('leap.treesitter').select() end,
        desc = 'Treesitter node selection',
      },
      {
        'gA',
        mode = { 'n', 'x', 'o' },
        'V<cmd>lua require("leap.treesitter").select()<cr>',
        desc = 'Treesitter node selection linewise',
      },
    },
  },

  {
    'ggandor/flit.nvim',
    dependencies = {
      'ggandor/leap.nvim',
      'tpope/vim-repeat',
    },
    opts = {},
    keys = {
      { 'f', mode = { 'n', 'v' }, desc = 'Flit f' },
      { 'F', mode = { 'n', 'v' }, desc = 'Filt F' },
      { 't', mode = { 'n', 'v' }, desc = 'Filt t' },
      { 'T', mode = { 'n', 'v' }, desc = 'Filt T' },
    },
  },
}
