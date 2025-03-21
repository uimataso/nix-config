return {
  'oskarrrrrrr/symbols.nvim',
  command = { 'Symbols', 'SymbolsClose' },

  keys = {
    { ',s', '<cmd>Symbols<cr>' },
    { ',S', '<cmd>SymbolsClose<cr>' },
  },

  config = function()
    local r = require('symbols.recipes')
    require('symbols').setup(r.DefaultFilters, r.AsciiSymbols, {
      -- custom settings here
      -- e.g. hide_cursor = false
    })
  end,
}
