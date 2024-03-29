return {
  'm4xshen/hardtime.nvim',
  cond = false,
  -- event = 'VeryLazy',
  lazy = false,
  command = 'Hardtime',
  disabled_filetypes = { 'qf', 'netrw', 'NvimTree', 'lazy', 'mason', 'oil' },
  dependencies = {
    'MunifTanjim/nui.nvim',
    'nvim-lua/plenary.nvim'
  },
  opts = {
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
  }
}
