local au = vim.api.nvim_create_autocmd
local ag = vim.api.nvim_create_augroup

-- Disable auto comment new line
au('FileType', {
  pattern = { '*' },
  callback = function()
    vim.opt.formatoptions:remove { 'c', 'r', 'o' }
  end
})

-- Delete trailing spaces and extra line when save file
au('BufWrite', {
  desc = 'Delete trailing spaces and extra line',
  callback = function()
    local pos = vim.fn.getpos('.')
    vim.cmd [[ %s/\s\+$//e ]]
    vim.cmd [[ %s/\n\+\%$//e ]]
    vim.fn.setpos('.', pos)
  end
})

-- Restore the cursor position after yank
local yank_restore_cursor = ag('yank_restore_cursor', {})
au({ 'VimEnter', 'CursorMoved' }, {
  group = yank_restore_cursor,
  desc = 'Tracking the cursor position',
  callback = function()
    Cursor_pos = vim.fn.getpos('.')
  end,
})

au('TextYankPost', {
  group = yank_restore_cursor,
  desc = 'Restore the cursor position after yank',
  callback = function()
    if vim.v.event.operator == 'y' then
      vim.fn.setpos('.', Cursor_pos)
    end
  end,
})

-- Yank highlighting
au('TextYankPost', {
  desc = 'Yank highlighting',
  callback = function()
    vim.highlight.on_yank({
      higroup = 'Yank',
      timeout = 300,
      priority = 250,
    })
  end,
})

-- Settings for terminal mode
au('TermOpen', {
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

-- Only focused window has cursorline
au('WinEnter', { command = 'setlocal cursorline' })
au('WinLeave', { command = 'setlocal nocursorline' })

-- Resize splits if window got resized
au({ 'VimResized' }, {
  group = ag('resize_splits', {}),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd('tabdo wincmd =')
    vim.cmd('tabnext ' .. current_tab)
  end,
})

-- Close some filetypes with <q>
au('FileType', {
  group = ag('close_with_q', {}),
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
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
au({ 'BufWritePre' }, {
  group = ag('auto_create_dir', {}),
  callback = function(event)
    if event.match:match('^%w%w+://') then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})

-- Correcting the filetype
local function corrft(pattern, ft)
  au('BufEnter', {
    pattern = { pattern },
    command = 'setf ' .. ft
  })
end

corrft('*qmk*/*.keymap', 'c') -- C for qmk file
corrft('*qmk*/*.def', 'c')

corrft('*manuscript/*.txt', 'markdown') -- Use md to open the book 'pure bash bible'
