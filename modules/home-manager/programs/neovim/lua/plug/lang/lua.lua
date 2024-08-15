return {
  {
    'neovim/nvim-lspconfig',
    ft = 'lua',
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = {
                  'vim',
                },
              },
            },
          },
        },
      },
    },
  },

  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lua',
    },
    opts = function(_, opts)
      local cmp = require('cmp')
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
        { name = 'nvim_lua' },
      }))
    end,
  },

  {
    'folke/neodev.nvim',
    opts = {
      library = { plugins = { 'nvim-dap-ui' }, types = true },
    },
  },
}
