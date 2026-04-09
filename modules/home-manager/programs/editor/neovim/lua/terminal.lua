local au = require('utils').au
local ag = require('utils').ag

local M = {}

M.terminals = {}

--- toggle float terminal
--- @param id string terminal identifier (e.g., "default", "lazygit")
--- @param cmd string|nil command to execute (default: vim.o.shell)
M.toggleterm = function(id, cmd)
  id = id or 'default'
  cmd = cmd or vim.o.shell

  if not M.terminals[id] then
    M.terminals[id] = {}
  end
  local term = M.terminals[id]

  -- Check if this specific terminal is already open
  local was_open = vim.api.nvim_win_is_valid(term.win or -1)

  -- Close all existing terminal windows
  for term_id, term_data in pairs(M.terminals) do
    if vim.api.nvim_win_is_valid(term_data.win or -1) then
      vim.api.nvim_win_hide(term_data.win)
    end
  end

  -- If this terminal was already open, we just closed it, so toggle off
  if was_open then
    return
  end

  if not vim.api.nvim_buf_is_valid(term.buf or -1) then
    term.buf = vim.api.nvim_create_buf(false, true)
  end

  local winopts = {
    relative = 'editor',
    col = math.floor(vim.o.columns * 0.1),
    row = math.floor(vim.o.lines * 0.1),
    width = math.floor(vim.o.columns * 0.8),
    height = math.floor(vim.o.lines * 0.8),
    style = 'minimal',
  }
  term.win = vim.api.nvim_open_win(term.buf, true, winopts)

  if vim.bo[term.buf].buftype ~= 'terminal' then
    vim.fn.jobstart(cmd, { term = true })
  end

  vim.cmd.startinsert()
end

-- Terminal mapping
vim.keymap.set({ 'n', 't' }, '<M-t>', M.toggleterm)
vim.keymap.set({ 'n', 't' }, '<M-g>', function()
  M.toggleterm('lazygit', 'lazygit')
end)

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>')
vim.keymap.set('t', '<C-w>', '<C-\\><C-n><C-w>')

-- Settings for terminal mode
ag('uima/TermSettings', function(g)
  au('TermOpen', {
    group = g,
    callback = function()
      vim.keymap.set('n', '<Esc><Esc>', '<cmd>close<cr>', { buffer = 0 })
      vim.keymap.set('n', '<BS>', '<Nop>', { buffer = 0 })
    end,
  })
end)
