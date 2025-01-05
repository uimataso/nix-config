local colorful_menu_draw = {
  components = {
    label = {
      width = { fill = true, max = 60 },
      text = function(ctx)
        local highlights_info = require('colorful-menu').highlights(ctx.item, vim.bo.filetype)
        if highlights_info ~= nil then
          return highlights_info.text
        else
          return ctx.label
        end
      end,
      highlight = function(ctx)
        local highlights_info = require('colorful-menu').highlights(ctx.item, vim.bo.filetype)
        local highlights = {}
        if highlights_info ~= nil then
          for _, info in ipairs(highlights_info.highlights) do
            table.insert(highlights, {
              info.range[1],
              info.range[2],
              group = ctx.deprecated and 'BlinkCmpLabelDeprecated' or info[1],
            })
          end
        end
        for _, idx in ipairs(ctx.label_matched_indices) do
          table.insert(highlights, { idx, idx + 1, group = 'BlinkCmpLabelMatch' })
        end
        return highlights
      end,
    },
  },
}

return {
  {
    'saghen/blink.cmp',
    lazy = false,
    dependencies = {
      'L3MON4D3/LuaSnip',
      'nvim-tree/nvim-web-devicons',
      'folke/lazydev.nvim',
      { 'xzbdmw/colorful-menu.nvim', opts = {} },
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
          -- draw = {
          --   treesitter = { 'lsp' },
          -- },
          draw = colorful_menu_draw,
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
          window = { border = require('config').border },
        },
      },
    },

    opts_extend = {
      'sources.completion.enabled_providers',
      'sources.compat',
      'sources.default',
    },
  },
}
