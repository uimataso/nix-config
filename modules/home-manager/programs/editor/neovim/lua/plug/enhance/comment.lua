return { -- I'm not really tested it, but I think this plugin has more function than buildin one (2024-08-24)
  'numToStr/Comment.nvim',
  keys = {
    { 'gc', mode = { 'n', 'v' }, desc = 'Line comment' },
    { 'gb', mode = { 'n', 'v' }, desc = 'Block comment' },
    { 'gcc', mode = { 'n' }, desc = 'Line comment' },
    { 'gbc', mode = { 'n' }, desc = 'Block comment' },
  },

  opts = {},
  config = function(_, opts)
    require('Comment').setup(opts)

    local ft = require('Comment.ft')
    ft({ 'openscad' }, ft.get('c'))
  end,
}
