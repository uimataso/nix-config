return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        pylsp = {
          settings = {
            pylsp = {
              plugins = {
                flake8 = { enabled = true, },
                pycodestyle = { enabled = false, },
                pyflakes = { enabled = false, },
              },
            }
          }
        },
      },
    }
  },
}
