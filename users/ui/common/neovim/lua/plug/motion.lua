return {
  {
    'numToStr/Comment.nvim',
    keys = {
      { 'gc', mode = { 'n', 'v' }, desc = 'Line comment' },
      { 'gb', mode = { 'n', 'v' }, desc = 'Block comment' },
    },
    config = true,
  },

  {
    'kylechui/nvim-surround',
    keys = {
      { 'cs', desc = 'Change the surround' },
      { 'ds', desc = 'Delete the surround' },
      { 'ys', desc = 'Add the surround' },
    },
    config = true
  },

  {
    'ggandor/leap.nvim',
    dependencies = {
      'ggandor/leap.nvim',
      'tpope/vim-repeat',
    },
    keys = {
      { 's',  mode = { 'n', 'x', 'o' }, '<Plug>(leap-forward-to)',    desc = 'Leap forward to' },
      { 'S',  mode = { 'n', 'x', 'o' }, '<Plug>(leap-backward-to)',   desc = 'Leap backward to', },
      { 'x',  mode = { 'x', 'o' },      '<Plug>(leap-forward-till)',  desc = 'Leap forward till', },
      { 'X',  mode = { 'x', 'o' },      '<Plug>(leap-backward-till)', desc = 'Leap backward till', },
      { 'gs', mode = { 'n', 'x', 'o' }, '<Plug>(leap-from-window)',   desc = 'Leap from window', },
      { 'gs', mode = { 'n', 'x', 'o' }, '<Plug>(leap-cross-window)',  desc = 'Leap from window', },
    },

    config = function()
      -- fix cursor highlight
      vim.api.nvim_create_autocmd(
        'User',
        {
          callback = function()
            vim.cmd.hi('Cursor', 'blend=100')
            vim.opt.guicursor:append { 'a:Cursor/lCursor' }
          end,
          pattern = 'LeapEnter'
        }
      )
      vim.api.nvim_create_autocmd(
        'User',
        {
          callback = function()
            vim.cmd.hi('Cursor', 'blend=0')
            vim.opt.guicursor:remove { 'a:Cursor/lCursor' }
          end,
          pattern = 'LeapLeave'
        }
      )
    end
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
    }
  },
}
