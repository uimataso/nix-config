return {
  {
    'ggandor/leap.nvim',
    dependencies = {
      'ggandor/leap.nvim',
      'tpope/vim-repeat',
    },
    keys = {
      { 's', mode = { 'n', 'x', 'o' }, '<Plug>(leap-forward)', desc = 'Leap forward' },
      { 'S', mode = { 'n', 'x', 'o' }, '<Plug>(leap-backward)', desc = 'Leap backward' },
      { 'x', mode = { 'x', 'o' }, '<Plug>(leap-forward-till)', desc = 'Leap forward till' },
      { 'X', mode = { 'x', 'o' }, '<Plug>(leap-backward-till)', desc = 'Leap backward till' },
      { 'gw', mode = { 'n', 'x', 'o' }, '<Plug>(leap-from-window)', desc = 'Leap from window' },
      {
        'gs',
        mode = { 'n', 'o' },
        function() require('leap.remote').action() end,
        desc = 'Leap remote',
      },
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

    config = function()
      -- Greying out the search area
      vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })
    end,
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
