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

  {
    'hedyhli/outline.nvim',
    enabled = false,
    dependencies = { 'onsails/lspkind.nvim' },
    cmd = 'Outline',
    keys = {
      {
        '<Leader>j',
        mode = { 'n' },
        function()
          require('outline').toggle()
        end,
        desc = 'Toggle Outline',
      },
    },

    opts = {
      outline_window = {
        position = 'left',
      },
      symbols = {
        icon_source = 'lspkind',
      },
    },
  },

  {
    'stevearc/aerial.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },

    keys = {
      {
        '<Leader>j',
        mode = { 'n' },
        function()
          require('aerial').toggle({ direction = 'left' })
        end,
        desc = 'Toggle Aerial',
      },
      {
        'gro',
        mode = { 'n' },
        function()
          require('aerial').snacks_picker()
        end,
        desc = '',
      },
    },

    opts = {
      on_attach = function(bufnr)
        -- Jump forwards/backwards with '{' and '}'
        vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
        vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
      end,
    },
  },
}
