return {
  { -- notification for lsp
    'j-hui/fidget.nvim',
    event = 'BufReadPre',

    opts = {
      notification = {
        window = {
          winblend = 0,
        },
      },
    },
  },

  {
    'smjonas/inc-rename.nvim',
    keys = {
      {
        'grn',
        mode = { 'n' },
        function()
          return ':IncRename ' .. vim.fn.expand('<cword>')
        end,
        expr = true,
      },
    },
    opts = {},
  },
}
