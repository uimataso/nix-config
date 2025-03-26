return {
  'gbprod/substitute.nvim',
  enabled = false,
  keys = {
    {
      's',
      mode = { 'n' },
      function()
        require('substitute').operator()
      end,
      desc = 'substitute',
    },
    {
      'ss',
      mode = { 'n' },
      function()
        require('substitute').line()
      end,
      desc = 'substitute line',
    },
    {
      'S',
      mode = { 'n' },
      function()
        require('substitute').eol()
      end,
      desc = 'substitute to eol',
    },
    {
      's',
      mode = { 'x' },
      function()
        require('substitute').visual()
      end,
      desc = 'substitute visual',
    },
  },
  opts = {},
}
