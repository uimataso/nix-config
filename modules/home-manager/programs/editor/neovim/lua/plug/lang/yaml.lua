return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        yamlls = {
          filetypes = { 'yaml', 'yaml.docker-compose', 'yaml.gitlab', 'yaml.openapi', 'json.openapi' },
        },
        vacuum = {},
      },
    },
  },

  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        yaml = { 'yamlfmt' },
      },

      formatters = {
        yamlfmt = {
          -- https://github.com/google/yamlfmt/blob/main/docs/command-usage.md#configuration-flags
          prepend_args = { '-formatter', 'retain_line_breaks_single=true' },
        },
      },
    },
  },
}
