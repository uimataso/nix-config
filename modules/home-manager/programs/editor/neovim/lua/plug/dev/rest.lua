return {
  'rest-nvim/rest.nvim',
  event = 'VeryLazy',
  cmd = 'Rest',

  opts = {},
  config = function(_, opts) vim.g.rest_nvim = opts end,
}
