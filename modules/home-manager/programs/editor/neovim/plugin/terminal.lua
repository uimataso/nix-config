local au = require('utils').au
local ag = require('utils').ag

local M = {}

--- toggle float terminal
M.toggleterm = function()
  if vim.api.nvim_win_is_valid(M.win or -1) then
    vim.api.nvim_win_hide(M.win)
    return
  end

  if not vim.api.nvim_buf_is_valid(M.buf or -1) then
    M.buf = vim.api.nvim_create_buf(false, true)
  end

  local winopts = {
    relative = 'editor',
    col = math.floor(vim.o.columns * 0.1),
    row = math.floor(vim.o.lines * 0.1),
    width = math.floor(vim.o.columns * 0.8),
    height = math.floor(vim.o.lines * 0.8),
    border = require('config').border,
    style = 'minimal',
  }
  M.win = vim.api.nvim_open_win(M.buf, true, winopts)

  if vim.bo[M.buf].buftype ~= 'terminal' then
    vim.fn.termopen(vim.o.shell)
  end

  vim.cmd.startinsert()
end

-- Terminal mapping
vim.keymap.set({ 'n', 't' }, '<C-t>', M.toggleterm)
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>')
vim.keymap.set('t', '<C-w>', '<C-\\><C-n><C-w>')

-- Settings for terminal mode
ag('uima/TermSettings', function(g)
  au('TermOpen', {
    group = g,
    callback = function(opts)
      vim.cmd('startinsert')
      vim.cmd('setlocal nonu')
      vim.cmd('setlocal signcolumn=no')

      vim.keymap.set('n', '<Esc><Esc>', '<cmd>close<cr>', { buffer = 0 })
      vim.keymap.set('n', '<BS>', '<Nop>', { buffer = 0 })
    end,
  })
end)
