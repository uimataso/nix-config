return {
  {
    'hrsh7th/nvim-cmp',
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'onsails/lspkind.nvim',

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
          ['<C-y>'] = cmp.mapping(
            cmp.mapping.confirm {
              behavior = cmp.ConfirmBehavior.Insert,
              select = true,
            }, { 'i', 'c' }),
          -- FIXME: config buildin snippet after 0.11, if `vim.lsp.completion.enable` is avaliable
          -- [see this snip](https://gist.github.com/MariaSolOs/2e44a86f569323c478e5a078d0cf98cc)
          -- and `:h lsp-config`
          ['<PageDown>'] = cmp.mapping(
            cmp.mapping.confirm {
              behavior = cmp.ConfirmBehavior.Insert,
              select = true,
            }, { 'i', 'c' }),
          ['<C-x>'] = cmp.mapping.close(),
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
        },

        sources = {
          { name = 'latex_symbols' },
          { name = 'treesitter' },
          { name = 'buffer' },
          { name = 'path' },
        },

        preselect = cmp.PreselectMode.None,

        formatting = {
          fields = { 'abbr', 'kind' },
          format = function(entry, vim_item)
            vim_item.menu = nil

            if vim.tbl_contains({ 'path' }, entry.source.name) then
              local icon, hl_group = require('nvim-web-devicons').get_icon(entry:get_completion_item().label)
              if icon then
                vim_item.kind = icon
                vim_item.kind_hl_group = hl_group
                return vim_item
              end
            end

            -- TODO: Icon has bug in wsl (blank space after icons)
            return require('lspkind').cmp_format({
              -- mode = 'symbol',
              mode = 'text',
              maxwidth = 40,
            })(entry, vim_item)
          end
        },

        -- For popup delay
        completion = {
          autocomplete = false,
        },

        enabled = function()
          -- Disable completion in comments
          local context = require 'cmp.config.context'
          -- Keep command mode completion enabled when cursor is in a comment
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
      -- Delay popup menu
      local timer = nil
      vim.api.nvim_create_autocmd({ "TextChangedI", "CmdlineChanged" }, {
        pattern = "*",
        callback = function()
          if timer then
            vim.loop.timer_stop(timer)
            timer = nil
          end
          timer = vim.loop.new_timer()
          timer:start(250, 0, vim.schedule_wrap(function()
            require('cmp').complete({ reason = require('cmp').ContextReason.Auto })
          end))
        end
      })

      for _, source in ipairs(opts.sources) do
        source.group_index = source.group_index or 1
      end
      require("cmp").setup(opts)
    end,
  },
}
