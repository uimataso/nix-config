return {
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { 'bash-language-server', 'shellcheck' })
    end,
  },

  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        bashls = {},
      },
    }
  },
}
