return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        nil_ls = {
          settings = {
            nil_ls = {
              formatting = {
                command = { 'nix fmt' },
              },
            },
          },
        },
      },
    },
  },
}
