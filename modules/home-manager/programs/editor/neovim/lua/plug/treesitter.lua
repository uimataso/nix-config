return {
  'nvim-treesitter/nvim-treesitter',
  event = 'BufReadPost',
  build = ':TSUpdate',
  dependencies = {
    'nvim-treesitter/playground',
    -- parser for nu-lang
    'nushell/tree-sitter-nu',
  },

  keys = {
    {
      '<Leader>hi',
      function() vim.print(vim.treesitter.get_captures_at_cursor(0)) end,
      desc = 'Print treesitter structure',
    },
  },

  main = 'nvim-treesitter.configs',

  opts = {
    ensure_installed = {
      'awk',
      'bash',
      'c',
      'corn',
      'diff',
      'gitattributes',
      'gitcommit',
      'git_config',
      'gitignore',
      'git_rebase',
      'html',
      'http',
      'json',
      'lua',
      'markdown',
      'markdown_inline',
      'nix',
      'nu',
      'org',
      'python',
      'javascript',
      'query',
      'rust',
      'toml',
      'vim',
      'vimdoc',
      'yaml',
    },
    -- ignore_install = { '' },

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
}
