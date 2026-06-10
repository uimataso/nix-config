local ag = require('uima').ag

-- TODO:
-- make `viwp` dot repeat able

-- to see which char map to which mode:
-- :h map-table

-- Keyboard specific
vim.keymap.set('', '+', 'j', { remap = true })
vim.keymap.set('', '-', 'k', { remap = true }) -- remapped in `oil.nvim`
vim.keymap.set('i', '<PageDown>', '<Nop>')
vim.keymap.set('i', '<PageUp>', '<Nop>')

vim.keymap.set('', '<PageUp>', '<C-u>', { remap = true })
vim.keymap.set('', '<PageDown>', '<C-d>', { remap = true })
vim.keymap.set('', '<Home>', '^', { remap = true })
vim.keymap.set('', '<End>', '$', { remap = true })

-------------------
-- [INSERT MODE] --
-------------------

vim.keymap.set('i', '<C-h>', '<C-w>') -- map <C-BS> to <C-w>
vim.keymap.set('i', '<C-Left>', '<C-o>b')
vim.keymap.set('i', '<C-Right>', '<C-o>w')
vim.keymap.set('i', '<Home>', '<C-o>^')
vim.keymap.set('i', '<End>', '<C-o>$')
vim.keymap.set('i', '<C-l>', '<C-o><cmd>nohlsearch<cr>')

-- Snippet
vim.keymap.set('i', '<C-x><C-s>', '<C-]>')

----------------
-- [TERMINAL] --
----------------

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>')
vim.keymap.set('t', '<C-w>', '<C-\\><C-n><C-w>')

---------------
-- [FEATURE] --
---------------

-- Restart
vim.keymap.set('n', '<leader>R', function()
  local session = vim.fn.stdpath('state') .. '/restart_session.vim'
  vim.cmd('mksession! ' .. vim.fn.fnameescape(session))
  vim.cmd('restart source ' .. vim.fn.fnameescape(session))
end, { desc = 'Restart Neovim' })

-- Alt File
vim.keymap.set('n', '<BS>', '<C-^>')
-- disable for these buffer
ag('uima/DisableBsAltFile', function(au)
  local callback = function(event)
    -- disable switch alt file
    vim.keymap.set('n', '<BS>', '<Nop>', { buffer = event.buf })
  end
  au('TermOpen', { callback = callback })
  au('FileType', {
    pattern = { 'oil' },
    callback = callback,
  })
end)

-- Resize window
vim.keymap.set('n', '<C-Right>', '<C-w>>')
vim.keymap.set('n', '<C-Left>', '<C-w><')
vim.keymap.set('n', '<C-Up>', '<C-w>+')
vim.keymap.set('n', '<C-Down>', '<C-w>-')

-- Quickfix
vim.keymap.set('n', '<leader>q', "<cmd>lua require('uima.qf').toggle('qf')<cr>")
vim.keymap.set('n', ']q', '<cmd>try | cnext | catch | cfirst | catch | endtry<cr>')
vim.keymap.set('n', '[q', '<cmd>try | cprevious | catch | clast | catch | endtry<cr>')
vim.keymap.set('n', '<C-j>', ']q', { remap = true })
vim.keymap.set('n', '<C-k>', '[q', { remap = true })
-- vim.keymap.set('n', '<C-n>', '<cmd>try | cnewer | catch | endtry<cr>')
-- vim.keymap.set('n', '<C-p>', '<cmd>try | colder | catch | endtry<cr>')

-- Spell check
vim.keymap.set('n', '<Leader>ts', '<cmd>setlocal spell!<CR>')

-- Switch conceal
vim.keymap.set('n', '<Leader>tc', function()
  vim.o.conceallevel = vim.o.conceallevel > 0 and 0 or 2
end, { silent = true, desc = 'Toggle conceal' })

-- Treesitter inspect
vim.keymap.set('n', '<Leader>hi', '<cmd>Inspect<cr>')

-- Fast substitute
vim.keymap.set('n', '<leader>sw', 'viw"-y:%s/<C-r>-/<C-r>-/g<left><left>')
vim.keymap.set('v', '<leader>sw', '"-y:%s/<C-r>-/<C-r>-/g<left><left>')

-- Quick shell command
vim.keymap.set('n', '!', ':terminal ')

-- Run cmd and open the output in split
vim.api.nvim_create_user_command('RunCmd', function(opts)
  local lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, true)
  local content = table.concat(lines, '\n')

  local cmd = opts.args

  if vim.trim(opts.args) == '' then
    vim.notify('command is empty', vim.log.levels.WARN)
    return
  end

  local start_time = vim.uv.now()

  local output = vim.fn.systemlist(cmd, content)

  local elapsed = vim.uv.now() - start_time
  vim.notify(string.format('done in %d ms', elapsed), vim.log.levels.INFO)

  -- open in a new scratch split buffer
  local split_cmd = opts.bang and 'split' or 'vsplit'
  vim.cmd(split_cmd .. ' | enew')
  local out_buf = vim.api.nvim_get_current_buf()
  vim.bo[out_buf].buftype = 'nofile'

  vim.api.nvim_buf_set_lines(out_buf, 0, -1, false, output)
end, { range = true, nargs = '*', bang = true })

vim.keymap.set('', '<Leader>rs', ':RunCmd ', { desc = 'Run command in split' })
vim.keymap.set('n', '<Leader><Leader>rs', ':%RunCmd ', { desc = 'Run command in split' })

------------------
-- [YANK PASTE] --
------------------

-- Copy paste with clipboard
vim.keymap.set('', '<Leader>y', '"+y')
vim.keymap.set('', '<Leader>Y', '"+y$')
vim.keymap.set('', '<Leader>p', '"+p')
vim.keymap.set('', '<Leader>P', '"+P')
vim.keymap.set('', '<Leader><Leader>y', "gg\"+yG''")

-- Paste without whitespace
vim.keymap.set('n', 'yp', function()
  local yanked_text = vim.fn.getreg(vim.v.register)
  yanked_text = yanked_text:gsub('\n$', '')
  yanked_text = yanked_text:gsub('^%s+', '')
  vim.fn.setreg('p', yanked_text)
  return '"pp'
end, { expr = true })
vim.keymap.set('n', '<Leader>yp', '"+yp', { remap = true })

-- Comment and duplicate lines
vim.keymap.set('n', 'gyc', 'mzyyPgcc`z', { remap = true })
vim.keymap.set('x', 'gyc', "mzy'<Pgpgc`z", { remap = true })

-- Visual paste not overwrite register by default
vim.keymap.set('x', 'p', 'P')
vim.keymap.set('x', 'P', 'p')

-- Select the context just pasted
vim.keymap.set('', 'gp', function()
  local v = vim.fn.getregtype():sub(1, 1)
  if v == '' then
    return ''
  end
  -- `:h getregtype`: <C-V> is one character with value 0x16
  v = v:byte() == 0x16 and '<C-V>' or v
  return '`[' .. v .. '`]'
end, { expr = true, desc = 'Selecting the paste' })

-- Copy Full File-Path
local yank_filepath = function(full, range)
  return function()
    local path = vim.fn.expand('%:p')

    if not full then
      local cwd = vim.loop.cwd() .. '/'
      path = path:gsub('^' .. vim.pesc(cwd), '')
    end

    if range then
      local a, b = require('uima').get_selected_range()
      local range = a == b and tostring(a) or (a .. '-' .. b)
      path = path .. ':' .. range
    end

    vim.fn.setreg('+', path)
    print('yanked file path:', path)

    -- exit visual mode
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
  end
end
vim.keymap.set('n', '<leader>gyf', yank_filepath(false, false))
vim.keymap.set('x', '<leader>gyf', yank_filepath(false, true))
vim.keymap.set('n', '<leader>gyF', yank_filepath(true, false))
vim.keymap.set('x', '<leader>gyF', yank_filepath(true, true))

-- Copy text to clipboard with markdown codeblock format: ```{ft}{content}```
vim.api.nvim_create_user_command('CopyCodeBlock', function(opts)
  local lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, true)
  local lines = require('uima').unindent(lines)
  local content = table.concat(lines, '\n')
  local result = string.format('```%s\n%s\n```', vim.bo.filetype, content)
  vim.fn.setreg('+', result)
  print('yank code block:', vim.bo.filetype)
end, { range = true })
vim.keymap.set('x', '<leader>gyb', ':CopyCodeBlock<cr>')

-------------------
-- [ENHANCEMENT] --
-------------------

-- Search in visual mode
vim.keymap.set('x', '/', '<Esc>/\\%V')

-- Center the screen when search
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set('c', '<CR>', function()
  return vim.fn.getcmdtype() == '/' and '<cr>zzzv' or '<cr>'
end, { expr = true })

-- Block insert in line visual mode
vim.keymap.set('x', 'I', function()
  return vim.fn.mode() == 'V' and '^<C-v>I' or 'I'
end, { expr = true })
vim.keymap.set('x', 'A', function()
  return vim.fn.mode() == 'V' and '$<C-v>A' or 'A'
end, { expr = true })

-- Keep cursor position when join line
vim.keymap.set('n', 'J', 'mzJ`z:delmarks z<cr>')
vim.keymap.set('n', 'gJ', 'mzgJ`z:delmarks z<cr>')

-- '*' but not jump to next, e.g. just highlight the word under the cursor
-- ref: https://stackoverflow.com/a/49944815
vim.keymap.set('n', '*', function()
  vim.fn.setreg('/', '\\<' .. vim.fn.expand('<cword>') .. '\\>')
  vim.opt.hlsearch = true
end)
vim.keymap.set('n', 'g*', function()
  vim.fn.setreg('/', vim.fn.expand('<cword>'))
  vim.opt.hlsearch = true
end)
vim.keymap.set('x', '*', function()
  local lines = require('uima').get_selected_lines()
  local text = table.concat(lines or {}, '\n')
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<esc>', true, false, true), 'x', true)
  vim.fn.setreg('/', vim.fn.escape(text, '\\'))
  vim.opt.hlsearch = true
end)
vim.keymap.set('x', 'g*', '*', { remap = true })

-- Close file with <q>
ag('uima/CloseWithQ', function(au)
  au('FileType', {
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
