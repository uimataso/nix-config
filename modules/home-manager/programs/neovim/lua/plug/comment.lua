return {
  'numToStr/Comment.nvim',
  keys = {
    { 'gc', mode = { 'n', 'v' }, desc = 'Line comment' },
    { 'gb', mode = { 'n', 'v' }, desc = 'Block comment' },
  },
  opts = {},
  config = function(_, opts)
    require('Comment').setup(opts)

    local ft = require('Comment.ft')
    ft({ 'openscad' }, ft.get('c'))
  end,
}
