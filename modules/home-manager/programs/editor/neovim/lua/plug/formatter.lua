return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },

  ---@module 'conform.nvim'
  ---@type conform.setupOpts
  opts = {
    default_format_opts = {
      lsp_format = 'fallback',
    },

    formatters_by_ft = {
      html = { 'prettier' },
      javascript = { 'prettier' },
      lua = { 'stylua' },
      markdown = { 'prettier', 'injected' },
      python = { 'isort', 'black' },
      yaml = { 'yamlfmt' },
    },

    format_on_save = {
      lsp_format = 'fallback',
      timeout_ms = 1000,
    },

    formatters = {
      yamlfmt = {
        -- https://github.com/google/yamlfmt/blob/main/docs/command-usage.md#configuration-flags
        prepend_args = { '-formatter', 'retain_line_breaks_single=true' },
      },
    },
  },
}
