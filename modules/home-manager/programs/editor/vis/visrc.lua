require('vis')
require('plugins/filetype')

require('plugins/vis-commentary')

local colorizer = require('plugins/vis-colorizer')
colorizer.three = false
colorizer.text_colors.dark = 'black' -- somehow default will displayed as cyan

require('plugins/vis-surround')

vis.events.subscribe(vis.events.INIT, function()
  vis:command('set theme gruvbox-dark-moded')
end)

vis.events.subscribe(vis.events.WIN_OPEN, function(win)
  vis:command('set number on')
  vis:command('set relativenumbers on')
  vis:command('set autoindent on')
  vis:command('set cursorline on')
  vis:command('set showeof off')
  vis:command('set showtab on')
end)
