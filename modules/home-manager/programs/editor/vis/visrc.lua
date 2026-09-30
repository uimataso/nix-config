require('vis')
require('plugins/filetype')

--plugins--
--require('plugins/twofinger-surround')
--require('plugins/vis-commentary/vis-commentary')
--require('plugins/vis-ctags/ctags')
--require('plugins/vis-fzf-open/fzf-open')
--require('plugins/vis-modelines/vis-modelines')
--require('plugins/vis-surround/vis-surround')
--require('plugins/vis-vim-compatibility-pack/vis-vim-compatible')

-- global configuration --
vis.events.subscribe(vis.events.INIT, function()
  vis:command('set theme gruvbox-dark-moded')
end)

-- per-window configuration --
vis.events.subscribe(vis.events.WIN_OPEN, function(win)
  vis:command('set number on')
  vis:command('set relativenumbers on')
  vis:command('set autoindent on')
  vis:command('set cursorline on')
  vis:command('set showeof off')
  vis:command('set showtab on')
end)
