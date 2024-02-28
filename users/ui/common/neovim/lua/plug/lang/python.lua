return {
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { 'python-lsp-server' })
    end,
  },

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
