return {
  'HawkinsT/pathfinder.nvim',
  keys = {
    {
      'gf',
      mode = 'n',
      function() require('pathfinder').gf() end,
    },
    {
      'gF',
      mode = 'n',
      function() require('pathfinder').gF() end,
    },
    {
      '<leader>gf',
      mode = 'n',
      function() require('pathfinder').select_file() end,
    },
  },
}
