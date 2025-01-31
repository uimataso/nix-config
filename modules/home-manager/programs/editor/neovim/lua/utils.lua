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

return M
