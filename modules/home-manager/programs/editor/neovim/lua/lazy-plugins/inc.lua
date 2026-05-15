vim.pack.add({
  'https://github.com/monaqa/dial.nvim',
})

local dial_augend = require('dial.augend')
require('dial.config').augends:register_group({
  default = {
    dial_augend.integer.alias.decimal_int,
    dial_augend.integer.alias.hex,
    dial_augend.constant.alias.bool,
    dial_augend.date.alias['%Y/%m/%d'], -- date (2022/02/19, etc.)
  },
})

local dial_map = require('dial.map')
vim.keymap.set('n', '<C-a>', dial_map.inc_normal())
vim.keymap.set('n', '<C-x>', dial_map.dec_normal())
vim.keymap.set('v', '<C-a>', dial_map.inc_visual())
vim.keymap.set('v', '<C-x>', dial_map.dec_visual())
vim.keymap.set('v', 'g<C-a>', dial_map.inc_gvisual())
vim.keymap.set('v', 'g<C-x>', dial_map.dec_gvisual())
