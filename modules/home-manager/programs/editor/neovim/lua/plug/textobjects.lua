return {
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    event = 'VeryLazy',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },

    opts = {
      incremental_selection = {
        enable = true,
        keymaps = {
          node_incremental = 'v',
          node_decremental = 'V',
        },
      },

      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          -- TODO: capture a expression
          keymaps = {
            ['as'] = '@statement.outer',
            ['is'] = '@call.outer',

            ['il'] = '@assignment.lhs',
            ['ir'] = '@assignment.rhs',
            ['al'] = '@assignment.outer',

            ['io'] = '@frame.inner',
            ['ao'] = '@frame.outer',

            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['aa'] = '@parameter.outer',
            ['ia'] = '@parameter.inner',
            ['ab'] = '@block.outer',
            ['ib'] = '@block.inner',
          },
          selection_modes = {
            ['@parameter.outer'] = 'v', -- charwise
            ['@function.outer'] = 'V', -- linewise
            ['@class.outer'] = '<c-v>', -- blockwise
          },
          include_surrounding_whitespace = false,
        },

        swap = {
          enable = true,
          swap_next = {
            ['<leader>sp'] = '@parameter.inner',
          },
          swap_previous = {
            ['<leader>sP'] = '@parameter.inner',
          },
        },
      },
    },

    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
  },

  {
    'echasnovski/mini.ai',
    enabled = false,
    version = '*',
    event = { 'InsertEnter', 'CmdlineEnter' },

    opts = {},
  },
}
