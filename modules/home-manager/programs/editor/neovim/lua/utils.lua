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
---@param highlight_ns integer | string
---@param highlight_group string
M.overwrite_diagnostic_highlight = function(diagnostic_ns, highlight_ns, highlight_group)
  if type(highlight_ns) == 'string' then
    highlight_ns = vim.api.nvim_create_namespace(highlight_ns)
  end

  -- add sepll highlight group
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

  local filter_diagnostics = function(diagnostics)
    local filtered_diagnostics = {}
    for _, d in pairs(diagnostics) do
      if d.namespace ~= diagnostic_ns then
        table.insert(filtered_diagnostics, d)
      end
    end
    return filtered_diagnostics
  end

  local orig_signs_handler = vim.diagnostic.handlers.signs
  vim.diagnostic.handlers.signs = {
    show = function(ns, bufnr, dias, opts)
      orig_signs_handler.show(ns, bufnr, filter_diagnostics(dias), opts)
    end,
    hide = orig_signs_handler.hide,
  }

  local orig_underline_handler = vim.diagnostic.handlers.underline
  vim.diagnostic.handlers.underline = {
    show = function(ns, bufnr, dias, opts)
      orig_underline_handler.show(ns, bufnr, filter_diagnostics(dias), opts)
    end,
    hide = orig_underline_handler.hide,
  }
end

---@param lists any[][]
---@return any[] merged_list
M.list_merge = function(lists)
  local ret = {}
  for _, list in pairs(lists) do
    vim.list_extend(ret, list)
  end
  return ret
end

---@param bufnr integer
---@param lnum integer
M.get_line_with_highlight = function(bufnr, lnum)
  local line = vim.api.nvim_buf_get_lines(0, lnum, lnum + 1, false)[1]

  local ret = {}
  local cur = { text = '', hl = nil }

  for i = 1, #line do
    local c = line:sub(i, i)

    local hls = vim.treesitter.get_captures_at_pos(0, lnum, i - 1)
    local new_hl = hls[#hls]
    local new_hl = new_hl and '@' .. new_hl.capture or nil

    if new_hl ~= cur.hl then
      table.insert(ret, { cur.text, cur.hl })
      cur = { text = c, hl = new_hl }
    else
      cur.text = cur.text .. c
    end
  end

  table.insert(ret, { cur.text, cur.hl })

  return ret
end

return M
