return {
  {
    'hrsh7th/nvim-cmp',
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'onsails/lspkind.nvim',

      'saadparwaiz1/cmp_luasnip',

      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',

      'kdheepak/cmp-latex-symbols',
    },

    keys = {
      { '<C-f>', mode = 'c', '<C-f>a<Esc>', desc = 'Use insert mode in commandline mode (a<esc> for close the cmp menu)' },
    },

    opts = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'

      -- ':' mode
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' },
          { name = 'cmdline' }
        }),
        formatting = {
          fields = { 'abbr' },
        },
      })

      -- '/' mode
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        },
        formatting = {
          fields = { 'abbr' },
        },
      })

      return {
        mapping = {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = false }),
          ['<C-y>'] = cmp.mapping(
            cmp.mapping.confirm {
              behavior = cmp.ConfirmBehavior.Insert,
              select = true,
            }, { 'i', 'c' }),
          ['<C-x>'] = cmp.mapping.close(),
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
        },

        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        sources = {
          { name = 'luasnip' },

          { name = 'latex_symbols' },

          { name = 'treesitter' },
          { name = 'buffer' },
          { name = 'path' },
        },

        preselect = cmp.PreselectMode.None,

        formatting = {
          fields = { 'abbr', 'kind' },
          format = function(entry, vim_item)
            if vim.tbl_contains({ 'path' }, entry.source.name) then
              local icon, hl_group = require('nvim-web-devicons').get_icon(entry:get_completion_item().label)
              if icon then
                vim_item.kind = icon
                vim_item.kind_hl_group = hl_group
                return vim_item
              end
            end
            return require('lspkind').cmp_format({ with_text = false })(entry, vim_item)
          end
        },

        enabled = function()
          -- disable completion in comments
          local context = require 'cmp.config.context'
          -- keep command mode completion enabled when cursor is in a comment
          if vim.api.nvim_get_mode().mode == 'c' then
            return true
          else
            return not context.in_treesitter_capture("comment")
                and not context.in_syntax_group("Comment")
                and not context.in_treesitter_capture("spell")
                and not context.in_treesitter_capture("text")
          end
        end
      }
    end,

    config = function(_, opts)
      for _, source in ipairs(opts.sources) do
        source.group_index = source.group_index or 1
      end
      require("cmp").setup(opts)
    end,
  },

  {
    'L3MON4D3/LuaSnip',
    event = { 'InsertEnter', 'CmdlineEnter' },
    keys = {
      { '<PageDown>', mode = { 'i', 's' }, function() require('luasnip').expand_or_jump() end, desc = 'Expand/Jump snippet' },
      { '<PageUp>',   mode = { 'i', 's' }, function() require('luasnip').jump(-1) end,         desc = 'Jump backword snippet' },
      {
        '<End>',
        mode = { 'i', 's' },
        function()
          if require('luasnip').choice_active() then require('luasnip').change_choice(1) end
        end,
        desc = 'Cycleing the snippet choice'
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
      require('luasnip.loaders.from_lua').load({ paths = '~/.config/nvim/snippets/' })
    end
  },

  {
    'danymat/neogen',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'L3MON4D3/LuaSnip',
    },
    keys = {
      { '<leader>nf', function() require('neogen').generate() end, desc = 'Create annotations' },
    },
    opts = {
      snippet_engine = 'luasnip',
    },
  },
}
