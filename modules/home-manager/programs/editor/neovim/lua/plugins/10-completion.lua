vim.pack.add({
  -- TODO: try v2
  { src = 'https://github.com/saghen/blink.cmp', version = 'v1.10.2' },
  'https://github.com/xzbdmw/colorful-menu.nvim',
})

---@module 'blink.cmp'
---@type blink.cmp.Config
require('blink.cmp').setup({
  keymap = {
    preset = 'default',
  },

  sources = {
    default = { 'lsp', 'buffer', 'snippets', 'path', 'lazydev' },
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
      selection = {
        preselect = false,
        auto_insert = true,
      },
    },
    menu = {
      border = 'none',
      -- draw = {
      --   treesitter = { 'lsp' },
      -- },
      draw = {
        columns = { { 'kind_icon' }, { 'label', gap = 1 } },
        components = {
          label = {
            text = function(ctx)
              return require('colorful-menu').blink_components_text(ctx)
            end,
            highlight = function(ctx)
              return require('colorful-menu').blink_components_highlight(ctx)
            end,
          },
        },
      },
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 500,
    },
  },

  cmdline = {
    keymap = {
      preset = 'cmdline',
      ['<Right>'] = {},
      ['<Left>'] = {},
    },
    completion = {
      menu = {
        auto_show = true,
      },
      list = {
        selection = {
          preselect = false,
        },
      },
    },
  },
})
