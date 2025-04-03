local au = require('utils').au
local ag = require('utils').ag

vim.opt.cursorline = true
vim.opt.scrolloff = 5
vim.opt.winborder = 'rounded'
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.inccommand = 'split'
vim.opt.list = true
vim.opt.listchars = { tab = '▸ ', trail = '·' }
vim.opt.fillchars:append { eob = ' ' }
vim.opt.fillchars:append { diff = '╱' }
-- vim.opt.conceallevel = 3

-- Column --
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 3
vim.opt.signcolumn = 'yes:1'
vim.opt.statuscolumn = '%l%s'

-- Search --
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.pumheight = 10
vim.opt.wildignorecase = true
vim.opt.wildignore = { '*.git/*', '*.tags', 'tags', '*.o', '*.class', '*models/*.pt' }
-- vim.opt.suffixesadd = '.md'

-- Spell --
vim.opt.spell = false
vim.opt.spellfile = vim.fn.stdpath('data') .. '/spell/en.utf-8.add'
vim.opt.spelllang = 'en_us,cjk'
vim.opt.spelloptions = 'camel'

-- Msic --
vim.opt.shortmess:append('I') -- no intro message
vim.opt.swapfile = false
vim.opt.updatetime = 100
vim.opt.mouse = ''

-- Disable default ftplugin mapping
vim.g.no_plugin_maps = true

-- Disable auto comment new line
ag('uima/Fromatoptions', function(g)
  au('FileType', {
    group = g,
    pattern = { '*' },
    callback = function()
      vim.opt.formatoptions:remove({ 'c', 'r', 'o' })
    end,
  })
end)

-- Delete trailing spaces and extra line when save file
-- TODO: command to toggle
ag('uima/DeleteTrailingSpace', function(g)
  au('BufWrite', {
    group = g,
    desc = 'Delete trailing spaces and extra line',
    callback = function()
      local pos = vim.fn.getpos('.')
      vim.cmd([[ %s/\s\+$//e ]])
      vim.cmd([[ %s/\n\+\%$//e ]])
      vim.fn.setpos('.', pos)
    end,
  })
end)

-- Yank highlighting
ag('uima/YankHighlight', function(g)
  au('TextYankPost', {
    group = g,
    desc = 'Yank highlighting',
    callback = function()
      vim.highlight.on_yank({
        higroup = 'Yank',
        timeout = 300,
        priority = 250,
      })
    end,
  })
end)

-- Restore the cursor position after yank
ag('uima/RestoreCursorAfterYank', function(g)
  au({ 'VimEnter', 'CursorMoved' }, {
    group = g,
    desc = 'Tracking the cursor position',
    callback = function()
      Cursor_pos = vim.fn.getpos('.')
    end,
  })

  au('TextYankPost', {
    group = g,
    desc = 'Restore the cursor position after yank',
    callback = function()
      if vim.v.event.operator == 'y' then
        vim.fn.setpos('.', Cursor_pos)
      end
    end,
  })
end)

-- Only focused window has cursorline
ag('uima/FocusedOnlyCursorline', function(g)
  au('WinEnter', { group = g, command = 'setlocal cursorline' })
  au('WinLeave', { group = g, command = 'setlocal nocursorline' })
end)

-- Resize splits if window got resized
ag('uima/ResizeSplit', function(g)
  au({ 'VimResized' }, {
    group = g,
    callback = function()
      local current_tab = vim.fn.tabpagenr()
      vim.cmd('tabdo wincmd =')
      vim.cmd('tabnext ' .. current_tab)
    end,
  })
end)

-- Auto create dir when saving a file, in case some intermediate directory does not exist
ag('uima/AutoCreateDir', function(g)
  au({ 'BufWritePre' }, {
    group = g,
    callback = function(event)
      if event.match:match('^%w%w+://') then
        return
      end
      local file = vim.loop.fs_realpath(event.match) or event.match
      vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
    end,
  })
end)

-- Correcting the filetype
ag('uima/CorrectFileType', function(g)
  local function corrft(pattern, ft)
    au('BufEnter', {
      group = g,
      pattern = { pattern },
      command = 'setf ' .. ft,
    })
  end

  corrft('*qmk*/*.keymap', 'c') -- C for qmk file
  corrft('*qmk*/*.def', 'c')

  vim.filetype.add({
    pattern = {
      ['openapi.*%.ya?ml'] = 'yaml.openapi',
      ['openapi.*%.json'] = 'json.openapi',
    },
  })
end)
