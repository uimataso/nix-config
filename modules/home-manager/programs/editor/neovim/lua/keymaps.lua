-- to see which char map to which mode:
-- :h map-table

-- Make space as leader key
vim.keymap.set('', '<Space>', '<Nop>')
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- Execute lua
vim.keymap.set('n', '<Leader><Leader>x', '<cmd>source %<CR>')
vim.keymap.set('n', '<Leader>xx', ':.lua<CR>')
vim.keymap.set('v', '<Leader>x', ':lua<CR>')

-- Insert mode mapping
vim.keymap.set('i', '<C-h>', '<C-w>') -- map <C-BS> to <C-w>
vim.keymap.set('i', '<C-Left>', '<C-o>b')
vim.keymap.set('i', '<C-Right>', '<C-o>w')
vim.keymap.set('i', '<Home>', '<C-o>^')
vim.keymap.set('i', '<End>', '<C-o>$')

vim.keymap.set({ 'i', 's' }, '<PageDown>', function()
  if vim.snippet.active({ direction = 1 }) then
    vim.snippet.jump(1)
  end
end, { expr = true, desc = 'Jump to next snip placeholder' })
vim.keymap.set({ 'i', 's' }, '<PageUp>', function()
  if vim.snippet.active({ direction = -1 }) then
    vim.snippet.jump(-1)
  end
end, { expr = true, desc = 'Jump to prev snip placeholder' })

-- Terminal mapping
vim.keymap.set({ 'n', 't' }, '<C-t>', require('term').toggleterm)
vim.keymap.set('t', '<C-[>', '<C-\\><C-n>')
vim.keymap.set('t', '<C-w>', '<C-\\><C-n><C-w>')

-- Buffer movement
vim.keymap.set('n', '<BS>', '<C-^>')
vim.keymap.set('n', '<Tab>', '<cmd>bn<cr>')
vim.keymap.set('n', '<S-Tab>', '<cmd>bp<cr>')

-- Quickfix
vim.keymap.set('n', '<C-n>', '<cmd>cn<cr>')
vim.keymap.set('n', '<C-p>', '<cmd>cp<cr>')

-- Remapping navigation keys
vim.keymap.set('', '<PageUp>', '<C-u>')
vim.keymap.set('', '<PageDown>', '<C-d>')
vim.keymap.set('', '<Home>', '^')

vim.keymap.set('', '+', 'j')
vim.keymap.set('', '-', 'k')

-- Copy paste with clipboard
vim.keymap.set('', '<Leader>y', '"+y')
vim.keymap.set('', '<Leader>Y', '"+y$')
vim.keymap.set('', '<Leader>p', '"+p')
vim.keymap.set('', '<Leader>P', '"+P')
vim.keymap.set('', '<Leader><Leader>y', "gg\"+yG''")

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

-- Center the screen when search
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set('c', '<CR>', function() return vim.fn.getcmdtype() == '/' and '<cr>zzzv' or '<cr>' end, { expr = true })

-- '*' but not jump to next, eg. just highlight the word under the cursor
-- ref: https://stackoverflow.com/a/49944815
vim.keymap.set('n', '*', [[<cmd>let @/ = '\<' . expand('<cword>') . '\>' <bar> set hls <cr>]])
vim.keymap.set('n', 'g*', [[<cmd>let @/=expand('<cword>') <bar> set hls <cr>]])

-- Block insert in line visual mode
vim.keymap.set('x', 'I', function() return vim.fn.mode() == 'V' and '^<C-v>I' or 'I' end, { expr = true })
vim.keymap.set('x', 'A', function() return vim.fn.mode() == 'V' and '$<C-v>A' or 'A' end, { expr = true })

-- Repeat and search next
vim.keymap.set('n', '<M-n>', '.nzzzv')

-- Spell check
vim.keymap.set('n', '<Leader>sp', '<cmd>setlocal spell! spelllang=en_us<CR>')

-- Switch conceal
vim.keymap.set(
  'n',
  '<Leader>zc',
  function() vim.o.conceallevel = vim.o.conceallevel > 0 and 0 or 3 end,
  { silent = true, desc = 'Toggle conceal' }
)

vim.keymap.set('n', '<Leader>hi', '<cmd>Inspect<cr>')

-- Diagnostic
vim.keymap.set('n', '<Leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostics in a floating window' })
vim.keymap.set('n', '<Leader>dj', vim.diagnostic.goto_prev, { desc = 'Move to the prev diagnostic' })
vim.keymap.set('n', '<Leader>dk', vim.diagnostic.goto_next, { desc = 'Move to the next diagnostic' })
vim.keymap.set('n', '<Leader>dl', vim.diagnostic.setloclist, { desc = 'Add diagnostic to loclist' })

-- LSP
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('uima/LspKeymap', { clear = true }),
  callback = function(args)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'vim.lsp.buf.definition()' })
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'vim.lsp.buf.declaration()' })
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = 'vim.lsp.buf.implementation()' })
    vim.keymap.set('n', 'grr', vim.lsp.buf.references, { desc = 'vim.lsp.buf.references()' })
    vim.keymap.set('n', 'grn', vim.lsp.buf.rename, { desc = 'vim.lsp.buf.rename()' })
    vim.keymap.set({ 'n', 'x' }, 'gra', vim.lsp.buf.code_action, { desc = 'vim.lsp.buf.code_action()' })
    vim.keymap.set({ 'n', 'x' }, '<Leader>a', vim.lsp.buf.code_action, { desc = 'vim.lsp.buf.code_action()' })
    vim.keymap.set('i', '<C-s>', vim.lsp.buf.signature_help, { desc = 'vim.lsp.buf.signature_help()' })

    -- Workspace
    vim.keymap.set('n', '<Leader>wa', vim.lsp.buf.add_workspace_folder, { desc = 'Add workspace folder' })
    vim.keymap.set('n', '<Leader>wr', vim.lsp.buf.remove_workspace_folder, { desc = 'Remove workspace folder' })
    vim.keymap.set(
      'n',
      '<Leader>wl',
      function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
      { desc = 'Display the workspace folders' }
    )
  end,
})

-- Copy text to clipboard with markdown codeblock format: ```{ft}{content}```
vim.api.nvim_create_user_command('CopyCodeBlock', function(opts)
  local lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, true)
  local content = table.concat(lines, '\n')
  local result = string.format('```%s\n%s\n```', vim.bo.filetype, content)
  vim.fn.setreg('+', result)
end, { range = true })

vim.keymap.set('', '<Leader>cy', ':CopyCodeBlock<cr>', { desc = 'Copy text with markdown codeblock style' })

-- Abbr for command mode
local function cabbrev(lhs, rhs)
  -- only working on ':' mode
  local command = "cnoreabbrev <expr> %s ((getcmdtype() is# ':' && getcmdline() is# '%s')?('%s'):('%s'))"
  vim.cmd(command:format(lhs, lhs, rhs, lhs))
end

cabbrev('f', 'find')
cabbrev('s', 'sp')
cabbrev('v', 'vs')
-- Write file as root
cabbrev('sudow', 'w !sudo tee %')
cabbrev('doasw', 'w !doas tee %')
