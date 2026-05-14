local M = {}

local oc = require('opencode')

M.init_buf_setting = function()
  vim.bo[M.buf].filetype = 'markdown'

  local map = function(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, { buffer = M.buf })
  end
  map('n', '<esc><esc>', M.hide)
end

M.hide = function()
  if vim.api.nvim_win_is_valid(M.win or -1) then
    vim.api.nvim_win_hide(M.win)
  end
end

M.toggle = function()
  if vim.api.nvim_win_is_valid(M.win or -1) then
    M.hide()
    return
  end

  if oc.find_port_in_tmux() == nil then
    vim.notify('opencode not found', vim.log.levels.ERROR)
  end

  if not vim.api.nvim_buf_is_valid(M.buf or -1) then
    M.buf = vim.api.nvim_create_buf(false, true)
    M.init_buf_setting()
  end

  local w = math.floor(vim.o.columns * 0.8)
  local h = math.floor(vim.o.lines * 0.6)
  local winopts = {
    relative = 'editor',
    col = math.floor((vim.o.columns - w) / 2),
    row = math.floor((vim.o.lines - h) / 2),
    width = w,
    height = h,
  }
  M.win = vim.api.nvim_open_win(M.buf, true, winopts)
end

M.append_text = function(text)
  if not vim.api.nvim_buf_is_valid(M.buf or -1) then
    M.buf = vim.api.nvim_create_buf(false, true)
    M.init_buf_setting()
  end

  local lines = vim.split(text, '\n', { plain = true })
  local last = vim.api.nvim_buf_line_count(M.buf)
  vim.api.nvim_buf_set_lines(M.buf, last - 1, last - 1, false, lines)

  if not vim.api.nvim_win_is_valid(M.win or -1) then
    M.toggle()
  end
  vim.api.nvim_win_set_cursor(M.win, { vim.api.nvim_buf_line_count(M.buf), 0 })
end

M.send = function()
  if not M.buf or not vim.api.nvim_buf_is_valid(M.buf) then
    return
  end
  local lines = vim.api.nvim_buf_get_lines(M.buf, 0, -1, false)
  local content = table.concat(lines, '\n')
  if content == '' then
    return
  end

  local url = oc.url_in_tmux()
  oc.append_prompt(url, content)
  oc.submit_prompt(url)

  vim.api.nvim_buf_set_lines(M.buf, 0, -1, false, { '' })
  M.hide()
end

vim.keymap.set('n', '<M-p>', M.toggle)
vim.keymap.set('n', '<leader>ip', M.toggle)
vim.keymap.set('n', '<leader>i<cr>', M.send)
vim.keymap.set('n', '<leader>if', function()
  local cwd = vim.loop.cwd() .. '/'
  -- TODO: trim the filename with `opencode tmux`'s cwd, not neovim's cwd
  local filename = vim.fn.expand('%:p'):gsub('^' .. vim.pesc(cwd), '')
  M.append_text('@' .. filename .. ':' .. vim.fn.line('.'))
end)
vim.keymap.set('x', '<leader>if', function()
  local a, b = vim.fn.line('v'), vim.fn.line('.')
  if a > b then
    a, b = b, a
  end
  local range = a == b and tostring(a) or (a .. '-' .. b)
  local cwd = vim.loop.cwd() .. '/'
  local filename = vim.fn.expand('%:p'):gsub('^' .. vim.pesc(cwd), '')
  M.append_text('@' .. filename .. ':' .. range)
end)
vim.keymap.set('x', '<leader>iy', function()
  local lines = require('utils').get_selected_lines()
  local lines = require('utils').unindent(lines)
  local text = table.concat(lines or {}, '\n')
  M.append_text(text)
end)
vim.keymap.set('x', '<leader>ib', function()
  local lines = require('utils').get_selected_lines()
  local lines = require('utils').unindent(lines)
  local content = table.concat(lines, '\n')
  local text = string.format('```%s\n%s\n```', vim.bo.filetype, content)
  M.append_text(text)
end)

return M
