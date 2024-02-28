return {
  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'VeryLazy',
    main = 'ibl',
    opts = {
      scope = { enabled = false },
    },
  },

  {
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    opts = {
      signs = {
        add          = { text = '▎' },
        change       = { text = '▎' },
        delete       = { text = '契' },
        topdelete    = { text = '契' },
        changedelete = { text = '▎' },
      },
    }
  },

  {
    'lukas-reineke/headlines.nvim',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    ft = {
      'markdown',
    },
    opts = {
      markdown = {
        headline_highlights = { 'Headline' },
        codeblock_highlight = 'CodeBlock',
        dash_highlight = 'Dash',
        dash_string = '━',
        quote_highlight = 'Quote',
        quote_string = '┃',
        fat_headlines = false,
      }
    },
  },

  { -- Enhanced matchparen
    'utilyre/sentiment.nvim',
    event = 'VeryLazy',
    opts = {},
  },
}
