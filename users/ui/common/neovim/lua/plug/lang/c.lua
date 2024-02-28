return {
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { 'clangd', 'codelldb' })
    end,
  },

  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        clangd = {}
      },
    }
  },
}
