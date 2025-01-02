return {
  {
    'saghen/blink.cmp',
    lazy = false,
    dependencies = {
      'L3MON4D3/LuaSnip',
      'nvim-tree/nvim-web-devicons',
      'folke/lazydev.nvim',
    },
    version = '*',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-e>'] = { 'cancel', 'fallback' },
        ['<C-y>'] = { 'select_and_accept' },

        ['<C-p>'] = { 'show', 'select_prev', 'fallback' },
        ['<C-n>'] = { 'show', 'select_next', 'fallback' },

        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

        ['<Tab>'] = { 'snippet_forward', 'fallback' },
        ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
      },

      sources = {
        default = { 'lsp', 'path', 'buffer', 'lazydev' },
        providers = {
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            fallbacks = { 'lsp' },
          },
        },
      },

      completion = {
        list = {
          selection = 'auto_insert',
        },
        menu = {
          auto_show = function(ctx)
            return ctx.mode == 'cmdline'
          end,
          draw = {
            treesitter = { 'lsp' },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
          window = { border = require('config').border },
        },
      },

      snippets = {
        expand = function(snippet)
          require('luasnip').lsp_expand(snippet)
        end,
        active = function(filter)
          if filter and filter.direction then
            return require('luasnip').jumpable(filter.direction)
          end
          return require('luasnip').in_snippet()
        end,
        jump = function(direction)
          require('luasnip').jump(direction)
        end,
      },
    },

    opts_extend = {
      'sources.completion.enabled_providers',
      'sources.compat',
      'sources.default',
    },
  },

  {
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
    build = 'make install_jsregexp',

    event = { 'InsertEnter', 'CmdlineEnter' },

    keys = {
      {
        '<C-x><C-s>',
        mode = { 'i', 's' },
        function()
          require('luasnip').expand()
        end,
        desc = 'expand snippet',
      },
    },

    opts = function()
      local types = require('luasnip.util.types')
      local ft_fn = require('luasnip.extras.filetype_functions')

      return {
        history = true,
        updateevents = 'TextChanged,TextChangedI',
        delete_check_events = 'TextChanged',
        enable_autosnippets = true,
        store_selection_keys = '<Tab>',
        ft_func = ft_fn.from_pos_or_filetype,
        ext_opts = {
          [types.choiceNode] = {
            active = {
              virt_text = { { '●', 'MatchParen' } },
            },
          },
        },
      }
    end,

    config = function(_, opts)
      require('luasnip').setup(opts)
      require('luasnip.loaders.from_lua').load({
        paths = { vim.fn.stdpath('config') .. '/snippets' },
      })
    end,
  },
}
