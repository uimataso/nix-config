local M = {}

--- vim.api.nvim_create_autocmd
M.au = vim.api.nvim_create_autocmd
--- vim.api.nvim_create_augroup
---@param name string
---@param fn fun(group: integer)
M.ag = function(name, fn)
  local group = vim.api.nvim_create_augroup(name, { clear = true })
  fn(group)
end

--- overwrite the diagnostic highgroup with specify one
---@param diagnostic_ns integer
---@param highlight_ns integer
---@param highlight_group string
M.overwrite_diagnostic_highlight = function(diagnostic_ns, highlight_ns, highlight_group)
  vim.diagnostic.handlers[highlight_ns] = {
    show = function(namespace, bufnr, diagnostics, _)
      if namespace == diagnostic_ns then
        for _, diagnostic in ipairs(diagnostics) do
          vim.api.nvim_buf_add_highlight(
            bufnr,
            highlight_ns,
            highlight_group,
            diagnostic.lnum,
            diagnostic.col,
            diagnostic.end_col
          )
        end
      end
    end,

    hide = function(namespace, bufnr)
      if namespace == diagnostic_ns then
        vim.api.nvim_buf_clear_namespace(bufnr, highlight_ns, 0, -1)
      end
    end,
  }
end

--- add diagnostics to qflist
---@param buf integer|nil
---@param get_opts vim.diagnostic.GetOpts
M.get_diagnostic_to_qf = function(buf, get_opts)
  local diagnostics = vim.diagnostic.get(buf, get_opts)
  local qf_list = vim.diagnostic.toqflist(diagnostics)
  vim.fn.setqflist(qf_list, 'r')
end

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

return M
