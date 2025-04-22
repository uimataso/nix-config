local au = require('utils').au
local ag = require('utils').ag

-- to see which char map to which mode:
-- :h map-table

-- Insert mode mapping
vim.keymap.set('i', '<C-h>', '<C-w>') -- map <C-BS> to <C-w>
vim.keymap.set('i', '<C-Left>', '<C-o>b')
vim.keymap.set('i', '<C-Right>', '<C-o>w')
vim.keymap.set('i', '<Home>', '<C-o>^')
vim.keymap.set('i', '<End>', '<C-o>$')
vim.keymap.set('i', '<PageDown>', '<Nop>')
vim.keymap.set('i', '<PageUp>', '<Nop>')

-- Hover
local function show_documentation()
  local has_ufo, ufo = pcall(require, 'ufo')
  if has_ufo and ufo.peekFoldedLinesUnderCursor() then
    return
  end

  local filetype = vim.bo.filetype
  if filetype == 'vim' or filetype == 'help' then
    vim.cmd('h ' .. vim.fn.expand('<cword>'))
  elseif filetype == 'man' then
    vim.cmd('Man ' .. vim.fn.expand('<cword>'))
  elseif vim.fn.expand('%:t') == 'Cargo.toml' and require('crates').popup_available() then
    require('crates').show_popup()
  elseif filetype == 'rust' then
    vim.cmd.RustLsp { 'hover', 'actions' }
  else
    vim.lsp.buf.hover()
  end
end
vim.keymap.set(
  'n',
  'K',
  show_documentation,
  { silent = true, desc = 'vim.lsp.buf.hover() but more' }
)

vim.keymap.set('n', 'grs', function()
  vim.lsp.buf.signature_help()
end, { desc = 'vim.lsp.buf.signature_help()' })

-- Open in split
vim.keymap.set('n', '<Leader>gd', '<cmd>vsplit | lua vim.lsp.buf.definition()<cr>')
vim.keymap.set('n', '<Leader>gD', '<cmd>vsplit | lua vim.lsp.buf.declaration()<cr>')

-- Diagnostic
vim.keymap.set('n', '<leader>dr', vim.diagnostic.reset, { desc = 'vim.diagnostic.reset()' })

local diagnostic_virtual_lines = false
vim.keymap.set('n', '<leader>df', function()
  diagnostic_virtual_lines = not diagnostic_virtual_lines
  vim.diagnostic.config({ virtual_lines = diagnostic_virtual_lines })
end, { desc = 'vim.diagnostic.config({ virtual_lines = .. })' })

-- Snippet
vim.keymap.set('i', '<C-x><C-s>', '<C-]>')

-- Execute lua
vim.keymap.set('n', '<Leader><Leader>x', '<cmd>source %<CR>')
vim.keymap.set('n', '<Leader>xx', ':.lua<CR>')
vim.keymap.set('v', '<Leader>x', ':lua<CR>')

-- Buffer movement
vim.keymap.set('n', '<BS>', '<C-^>')
vim.keymap.set('n', '<Tab>', '<cmd>bn<cr>')
vim.keymap.set('n', '<S-Tab>', '<cmd>bp<cr>')

-- Remapping navigation keys (for my split keyboard)
vim.keymap.set('', '<PageUp>', '<C-u>', { remap = true })
vim.keymap.set('', '<PageDown>', '<C-d>', { remap = true })
vim.keymap.set('', '<Home>', '^', { remap = true })
vim.keymap.set('', '<End>', '$', { remap = true })
vim.keymap.set('', '+', 'j', { remap = true })
-- vim.keymap.set('', '-', 'k', { remap = true }) -- remap in `oil.nvim`

-- Copy paste with clipboard
vim.keymap.set('', '<Leader>y', '"+y')
vim.keymap.set('', '<Leader>Y', '"+y$')
vim.keymap.set('', '<Leader>p', '"+p')
vim.keymap.set('', '<Leader>P', '"+P')
vim.keymap.set('', '<Leader><Leader>y', "gg\"+yG''")

-- Paste without whitespace
vim.keymap.set('n', 'yp', function()
  local yanked_text = vim.fn.getreg('0')
  yanked_text = yanked_text:gsub('\n$', '')
  yanked_text = yanked_text:gsub('^%s+', '')
  vim.fn.setreg('p', yanked_text)
  return '"pp'
end, { expr = true })

-- Comment and duplicate lines
vim.keymap.set('n', 'ycc', 'mzyyPgcc`z', { remap = true })
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

-- Search in visual mode
vim.keymap.set('x', '/', '<Esc>/\\%V')

-- Center the screen when search
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set('c', '<CR>', function()
  return vim.fn.getcmdtype() == '/' and '<cr>zzzv' or '<cr>'
end, { expr = true })

-- Keep cursor position when join line
vim.keymap.set('n', 'J', 'mzJ`z:delmarks z<cr>')
vim.keymap.set('n', 'gJ', 'mzgJ`z:delmarks z<cr>')

-- '*' but not jump to next, e.g. just highlight the word under the cursor
-- ref: https://stackoverflow.com/a/49944815
vim.keymap.set('n', '*', [[<cmd>let @/ = '\<' . expand('<cword>') . '\>' <bar> set hls <cr>]])
vim.keymap.set('n', 'g*', [[<cmd>let @/ = expand('<cword>') <bar> set hls <cr>]])

-- Block insert in line visual mode
vim.keymap.set('x', 'I', function()
  return vim.fn.mode() == 'V' and '^<C-v>I' or 'I'
end, { expr = true })
vim.keymap.set('x', 'A', function()
  return vim.fn.mode() == 'V' and '$<C-v>A' or 'A'
end, { expr = true })

-- Repeat and search next
vim.keymap.set('n', '<M-n>', '.nzzzv')

-- Spell check
vim.keymap.set('n', '<Leader>sp', '<cmd>setlocal spell!<CR>')

-- Switch conceal
vim.keymap.set('n', '<Leader>zc', function()
  vim.o.conceallevel = vim.o.conceallevel > 0 and 0 or 3
end, { silent = true, desc = 'Toggle conceal' })

-- Treesitter inspect
vim.keymap.set('n', '<Leader>hi', '<cmd>Inspect<cr>')

-- Copy text to clipboard with markdown codeblock format: ```{ft}{content}```
vim.api.nvim_create_user_command('CopyCodeBlock', function(opts)
  local lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, true)
  local content = table.concat(lines, '\n')
  local result = string.format('```%s\n%s\n```', vim.bo.filetype, content)
  vim.fn.setreg('+', result)
end, { range = true })
vim.keymap.set(
  '',
  '<Leader>cy',
  ':CopyCodeBlock<cr>',
  { desc = 'Copy text with markdown codeblock style' }
)

-- LspInfo
vim.api.nvim_create_user_command('LspInfo', function(opts)
  vim.cmd [[ checkhealth vim.lsp ]]
end, {})

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
