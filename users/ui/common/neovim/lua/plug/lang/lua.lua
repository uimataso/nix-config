return {
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { 'lua-language-server', 'stylua' })
    end,
  },

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
                  -- Luasnip env
                  'ls', 's', 'sn', 'isn', 't', 'i', 'f', 'c', 'd', 'r',
                  'events', 'ai', 'extras', 'l', 'rep', 'p', 'm', 'n', 'dl',
                  'fmt', 'fmta', 'conds', 'postfix', 'types', 'parse', 'ms', 'k',
                },
              },
            },
          }
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
