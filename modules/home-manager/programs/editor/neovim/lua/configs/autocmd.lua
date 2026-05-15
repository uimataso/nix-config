local ag = require('uima').ag

-- Disable auto comment new line
ag('uima/Fromatoptions', function(au)
  au('FileType', {
    pattern = { '*' },
    callback = function()
      vim.opt.formatoptions:remove({ 'c', 'r', 'o' })
    end,
  })
end)

-- Auto re-read file if it has changed outside the neovim
ag('uima/CheckTime', function(au)
  au({ 'BufEnter', 'CursorHold', 'CursorHoldI', 'FocusGained', 'FocusLost' }, {
    pattern = { '*' },
    command = "if mode() != 'c' | checktime | endif",
  })
end)

-- Yank highlighting
ag('uima/YankHighlight', function(au)
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
end)

-- Restore the cursor position after yank
ag('uima/RestoreCursorAfterYank', function(au)
  local cursor_pos = vim.fn.getpos('.')

  au({ 'VimEnter', 'CursorMoved' }, {
    desc = 'Tracking the cursor position',
    callback = function()
      cursor_pos = vim.fn.getpos('.')
    end,
  })
  au('TextYankPost', {
    desc = 'Restore the cursor position after yank',
    callback = function()
      if vim.v.event.operator == 'y' then
        vim.fn.setpos('.', cursor_pos)
      end
    end,
  })
end)

-- Only focused window has cursorline
ag('uima/FocusedOnlyCursorline', function(au)
  local should_hide_cursor_line = function(e)
    local ft = vim.bo[e.buf].filetype
    return ft ~= 'DiffviewFiles'
  end

  au('WinEnter', {
    callback = function(event)
      if should_hide_cursor_line(event) then
        vim.o.cursorline = true
      end
    end,
  })
  au('WinLeave', {
    callback = function(event)
      if should_hide_cursor_line(event) then
        vim.o.cursorline = false
      end
    end,
  })
end)

-- Resize splits if window got resized
ag('uima/ResizeSplit', function(au)
  au({ 'VimResized' }, {
    callback = function()
      local current_tab = vim.fn.tabpagenr()
      vim.cmd('tabdo wincmd =')
      vim.cmd('tabnext ' .. current_tab)
    end,
  })
end)

-- Auto create dir when saving a file, in case some intermediate directory does not exist
ag('uima/AutoCreateDir', function(au)
  au({ 'BufWritePre' }, {
    callback = function(event)
      if event.match:match('^%w%w+://') then
        return
      end
      local file = vim.loop.fs_realpath(event.match) or event.match
      vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
    end,
  })
end)
