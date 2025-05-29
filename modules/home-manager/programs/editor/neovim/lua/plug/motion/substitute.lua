return {
  'gbprod/substitute.nvim',

  keys = {
    {
      's',
      mode = 'n',
      function()
        require('substitute').operator()
      end,
      desc = 'Substitute',
    },
    {
      'ss',
      mode = 'n',
      function()
        require('substitute').line()
      end,
      desc = 'Substitute line',
    },
    {
      'S',
      mode = 'n',
      function()
        require('substitute').eol()
      end,
      desc = 'Substitute EOL',
    },
    {
      's',
      mode = 'x',
      function()
        require('substitute').visual()
      end,
      desc = 'Substitute visual',
    },
  },

  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
}
