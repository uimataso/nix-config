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
      function()
        vim.print(vim.treesitter.get_captures_at_cursor(0))
      end,
      desc = 'Print treesitter structure',
    },
  },

  main = 'nvim-treesitter.configs',
  opts = {
    ensure_installed = {
      'vim',
      'vimdoc',
      'query',
      'bash',
      'awk',
      'nix',
      'diff',
      'corn',
      'python',
      'rust',
      'c',
      'lua',
      'markdown',
      'markdown_inline',
      'org',
      'html',
      'yaml',
      'toml',
      'json',
      'git_config',
      'git_rebase',
      'gitattributes',
      'gitcommit',
      'gitignore',
      'nu',
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
