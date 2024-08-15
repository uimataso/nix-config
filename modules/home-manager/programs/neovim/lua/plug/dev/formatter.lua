return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  opts = {
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'isort', 'black' },
      rust = { 'rustfmt', lsp_format = 'fallback' },
      -- TODO: nix fmt not works
      nix = { 'nix fmt', lsp_format = 'fallback' },
    },
    default_format_opts = {
      lsp_format = 'fallback',
    },
    format_on_save = {
      lsp_format = 'fallback',
      timeout_ms = 1000,
    },
  },
}
