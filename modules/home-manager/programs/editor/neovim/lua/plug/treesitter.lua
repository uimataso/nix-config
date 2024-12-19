return {
  'nvim-treesitter/nvim-treesitter',
  event = 'BufReadPost',
  build = ':TSUpdate',
  dependencies = {
    -- 'nvim-treesitter/playground',
    'nvim-treesitter/nvim-treesitter-textobjects',
    -- parser for nu-lang
    'nushell/tree-sitter-nu',
  },

  main = 'nvim-treesitter.configs',

  opts = {
    -- stylua: ignore start
    ensure_installed = {
      'c', 'rust', 'python', 'javascript', 'lua', 'nix', 'nu',
      'html', 'sql',
      'markdown', 'markdown_inline', 'org',
      'json', 'yaml', 'toml',
      'awk', 'bash', 'corn', 'diff', 'http', 'query',
      'gitattributes', 'gitcommit', 'git_config', 'gitignore', 'git_rebase',
      'vim', 'vimdoc',
    },
    -- stylua: ignore end

    highlight = {
      enable = true,
      disable = { 'help' },
    },

    indent = {
      enable = true,
      disable = { 'yaml' },
    },

    playground = {
      enable = true,
    },

    query_linter = {
      enable = true,
      -- use_virtual_text = true,
      -- lint_events = { 'BufWrite', 'CursorHold' },
    },

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
        keymaps = {
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = { query = '@class.inner', desc = 'Select inner part of a class region' },
          ['as'] = { query = '@local.scope', query_group = 'locals', desc = 'Select language scope' },
        },
        selection_modes = {
          ['@parameter.outer'] = 'v', -- charwise
          ['@function.outer'] = 'V', -- linewise
          ['@class.outer'] = '<c-v>', -- blockwise
        },
        include_surrounding_whitespace = true,
      },

      swap = {
        enable = true,
        swap_next = {
          ['<leader>sa'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>sA'] = '@parameter.inner',
        },
      },
    },
  },
}
