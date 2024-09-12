return {
  'gbprod/substitute.nvim',
  keys = {
    { 's', mode = { 'n' }, function() require('substitute').operator() end, desc = '' },
    { 'ss', mode = { 'n' }, function() require('substitute').line() end, desc = '' },
    { 'S', mode = { 'n' }, function() require('substitute').eol() end, desc = '' },
    { 's', mode = { 'x' }, function() require('substitute').visual() end, desc = '' },
  },
  opts = {},
}
