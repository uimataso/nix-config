return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        pylsp = {
          settings = {
            pylsp = {
              plugins = {
                flake8 = { enabled = true },
                pycodestyle = { enabled = false },
                pyflakes = { enabled = false },
              },
            },
          },
        },
      },
    },
  },

  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        python = { 'isort', 'black' },
      },
    },
  },
}
