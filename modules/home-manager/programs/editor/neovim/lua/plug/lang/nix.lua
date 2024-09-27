return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        nil_ls = {},
        nixd = {},
      },
    },
  },
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        -- TODO: nix fmt not works
        nix = { 'nix fmt', lsp_format = 'fallback' },
      },
    },
  },
}
