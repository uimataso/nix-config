return {
  'm4xshen/hardtime.nvim',
  event = 'VeryLazy',
  -- lazy = false,
  -- command = 'Hardtime',
  disabled_filetypes = { 'qf', 'netrw', 'NvimTree', 'lazy', 'oil' },
  dependencies = {
    'MunifTanjim/nui.nvim',
    'nvim-lua/plenary.nvim',
  },
  opts = {
    enabled = true,
    max_count = 3,
    disabled_keys = {
      ['<Up>'] = {},
      ['<Down>'] = {},
      ['<Left>'] = {},
      ['<Right>'] = {},
    },
    restricted_keys = {
      ['<Up>'] = { 'n', 'x' },
      ['<Down>'] = { 'n', 'x' },
      ['<Left>'] = { 'n', 'x' },
      ['<Right>'] = { 'n', 'x' },
    },
  },
}
