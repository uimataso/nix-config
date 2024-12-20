local M = {}

M.config = {
  cmd = { vim.o.shell },
}

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
    border = 'rounded',
    style = 'minimal',
  }
  M.win = vim.api.nvim_open_win(M.buf, true, winopts)

  if vim.bo[M.buf].buftype ~= 'terminal' then
    vim.fn.termopen(M.config.cmd)
  end

  vim.cmd.startinsert()
end

return M
