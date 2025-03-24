return {
  {
    'oskarrrrrrr/symbols.nvim',
    command = { 'Symbols', 'SymbolsClose' },

    keys = {
      { '<Leader>ss', '<cmd>Symbols<cr>' },
    },

    config = function()
      local r = require('symbols.recipes')
      require('symbols').setup(r.DefaultFilters, r.AsciiSymbols, {
        sidebar = {
          open_direction = 'right',
        },
      })
    end,
  },

  {
    'bassamsdata/namu.nvim',

    keys = {
      { '<C-s>', mode = 'n', ':Namu symbols<cr>', desc = 'Jump to LSP symbol' },
    },

    opts = {
      -- Enable the modules you want
      namu_symbols = {
        enable = true,
        options = {}, -- here you can configure namu
      },

      ui_select = { enable = false }, -- vim.ui.select() wrapper
    },
  },
}
