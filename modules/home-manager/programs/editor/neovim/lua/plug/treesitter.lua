return {
  {
    'nvim-treesitter/nvim-treesitter',
    event = 'BufReadPost',
    build = ':TSUpdate',
    dependencies = {
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
    },
  },
}
