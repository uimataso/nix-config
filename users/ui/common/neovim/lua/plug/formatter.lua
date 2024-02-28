-- if i even want switch one
-- https://github.com/stevearc/conform.nvim

return {
  'elentok/format-on-save.nvim',
  event = 'VeryLazy',
  dependencies = {
    'neovim/nvim-lspconfig',
  },

  opts = function()
    local formatters = require('format-on-save.formatters')

    return {
      exclude_path_patterns = {
        '/node_modules/',
        '.local/share/nvim/lazy',
      },
      formatter_by_ft = {
        rust = formatters.lsp,
        lua = formatters.lsp,
      }
    }
  end
}
