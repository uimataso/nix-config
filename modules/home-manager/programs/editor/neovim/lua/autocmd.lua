local au = vim.api.nvim_create_autocmd
local ag = function(name, fn)
  local group = vim.api.nvim_create_augroup(name, { clear = true })
  fn(group)
end

-- Disable auto comment new line
-- TODO: can I disable runtime/ftplugin completely?
ag('uima/Fromatoptions', function(g)
  au('FileType', {
    group = g,
    pattern = { '*' },
    callback = function() vim.opt.formatoptions:remove({ 'c', 'r', 'o' }) end,
  })
end)

-- Delete trailing spaces and extra line when save file
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

-- Check if we need to reload the file when it changed
ag(
  'uima/Checktime',
  function(g)
    au({ 'FocusGained', 'BufEnter', 'TermClose', 'TermLeave' }, {
      group = g,
      desc = 'Check if any file changed outsite of vim',
      command = 'checktime',
    })
  end
)

-- Restore the cursor position after yank
ag('uima/RestoreCursorAfterYank', function(g)
  au({ 'VimEnter', 'CursorMoved' }, {
    group = g,
    desc = 'Tracking the cursor position',
    callback = function() Cursor_pos = vim.fn.getpos('.') end,
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

-- Settings for terminal mode
ag('uima/TermSettings', function(g)
  au('TermOpen', {
    group = g,
    callback = function(opts)
      -- delay a small time, so some plugins that open a terminal on
      -- other window, don't exec these cmd
      vim.defer_fn(function()
        if vim.api.nvim_buf_get_option(0, 'buftype') == 'terminal' then
          vim.cmd('startinsert')
          vim.cmd('setlocal nonu')
          vim.cmd('setlocal signcolumn=no')
        end
      end, 100)
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

-- Close some filetypes with <q>
ag('uima/CloseWithQ', function(g)
  au('FileType', {
    group = g,
    pattern = {
      'PlenaryTestPopup',
      'help',
      'lspinfo',
      'man',
      'notify',
      'qf',
      'query',
      'spectre_panel',
      'startuptime',
      'tsplayground',
      'neotest-output',
      'checkhealth',
      'neotest-summary',
      'neotest-output-panel',
    },
    callback = function(event)
      vim.bo[event.buf].buflisted = false
      vim.keymap.set('n', 'q', '<cmd>quit<cr>', { buffer = event.buf, silent = true })
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

  corrft('*manuscript/*.txt', 'markdown') -- Use md to open the book 'pure bash bible'

  vim.filetype.add({
    pattern = {
      ['openapi.*%.ya?ml'] = 'yaml.openapi',
      ['openapi.*%.json'] = 'json.openapi',
    },
  })
end)
