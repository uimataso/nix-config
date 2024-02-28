return {
  'monaqa/dial.nvim',
  keys = {
    { '<C-a>',  mode = 'n', desc = 'Enhanced <C-a>' },
    { '<C-x>',  mode = 'n', desc = 'Enhanced <C-x>' },
    { '<C-a>',  mode = 'v', desc = 'Enhanced <C-a>' },
    { '<C-x>',  mode = 'v', desc = 'Enhanced <C-x>' },
    { 'g<C-a>', mode = 'v', desc = 'Enhanced g<C-a>' },
    { 'g<C-x>', mode = 'v', desc = 'Enhanced g<C-x>' },
  },

  config = function()
    local augend = require('dial.augend')
    require('dial.config').augends:register_group {
      default = {
        augend.integer.alias.decimal_int,
        augend.integer.alias.hex,
        augend.constant.alias.bool,
        augend.date.alias['%Y/%m/%d'], -- date (2022/02/19, etc.)
      },
    }

    vim.keymap.set('n', '<C-a>', require('dial.map').inc_normal())
    vim.keymap.set('n', '<C-x>', require('dial.map').dec_normal())
    vim.keymap.set('v', '<C-a>', require('dial.map').inc_visual())
    vim.keymap.set('v', '<C-x>', require('dial.map').dec_visual())
    vim.keymap.set('v', 'g<C-a>', require('dial.map').inc_gvisual())
    vim.keymap.set('v', 'g<C-x>', require('dial.map').dec_gvisual())
  end,
}
