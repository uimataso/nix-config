return {
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        html = { 'prettierd', 'prettier', stop_after_first = true },
      },
    },
  },
}
